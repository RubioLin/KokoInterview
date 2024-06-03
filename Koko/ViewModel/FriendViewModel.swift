import Foundation
import Combine

class FriendViewModel {
    
    // MARK: - Input & Output
    var input: Input!
    var output: Output!
    
    struct Input {
        let isRefreshingSubscriber: PassthroughSubject<Void, Never>
        let searchTextSubscriber: PassthroughSubject<String, Never>
        let inviteTableViewIsFoldSubscriber: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let currentState: AnyPublisher<FriendState, Never>
        let userInformation: AnyPublisher<UserInfomation?, Never>
        let friendTableViewDataSourcePublisher: AnyPublisher<[FriendInformation], Never>
        let invitationTableViewDataSourcePublisher: AnyPublisher<[FriendInformation], Never>
        let inviteTableViewIsFoldPublisher: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Property
    private var cancellables = Set<AnyCancellable>()
    private let apiManager = APIManager()
    private let currentState = CurrentValueSubject<FriendState, Never>(.noFriends)
    private let userInformation = CurrentValueSubject<UserInfomation?, Never>(nil)
    private let friendTableViewDataSourcePublisher = CurrentValueSubject<[FriendInformation], Never>([])
    private let invitationTableViewDataSourcePublisher = CurrentValueSubject<[FriendInformation], Never>([])
    private let inviteTableViewIsFoldPublisher = CurrentValueSubject<Bool, Never>(false)
    private var friendInformation = [FriendInformation]()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    // MARK: - Init
    init(state: FriendState) {
        currentState.send(state)
        
        fetchUserInformation()
        fetchFriendsAndInvitation(state: state)
        
        let friendTableViewRefreshing = PassthroughSubject<Void, Never>()
        friendTableViewRefreshing
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchFriendsAndInvitation(state: state)
            }
            .store(in: &cancellables)
        
        let searchTextSubscriber = PassthroughSubject<String, Never>()
        searchTextSubscriber
            .sink { [weak self] text in
                guard let self = self else { return }
                self.searchFriendInformation(text: text)
            }
            .store(in: &cancellables)
        
        let inviteTableViewIsFoldSubscriber = PassthroughSubject<Void, Never>()
        inviteTableViewIsFoldSubscriber
            .sink { [weak self] _ in
                guard let self = self else { return }
                let currentIsFold = self.inviteTableViewIsFoldPublisher.value
                self.inviteTableViewIsFoldPublisher.send(!currentIsFold)
            }
            .store(in: &cancellables)
        
        // Input
        input = Input(isRefreshingSubscriber: friendTableViewRefreshing,
                      searchTextSubscriber: searchTextSubscriber,
                      inviteTableViewIsFoldSubscriber: inviteTableViewIsFoldSubscriber)
        
        // Output
        output = Output(currentState: currentState.eraseToAnyPublisher(),
                        userInformation: userInformation.eraseToAnyPublisher(),
                        friendTableViewDataSourcePublisher: friendTableViewDataSourcePublisher.eraseToAnyPublisher(),
                        invitationTableViewDataSourcePublisher: invitationTableViewDataSourcePublisher.eraseToAnyPublisher(),
                        inviteTableViewIsFoldPublisher: inviteTableViewIsFoldPublisher.eraseToAnyPublisher())
        
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Method
    private func fetchFriendsAndInvitation(state: FriendState) {
        switch state {
        case .noFriends:
            fetchFriendInformationWithoutInvitationAndFriends()
        case .friendsWithoutInvitations:
            fetchFriendInformationWithoutInvitation()
        case .friendsWithInvitations:
            fetchFriendInformationWithInvitation()
        }
    }
    
    private func fetchUserInformation() {
        guard let request = apiManager.createRequest(url: APIEndpoints.fetchUserInformation) else { return }
        apiManager.operateRequestReturnDataTaskPublisher(request: request, type: User.self)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("Finished")
                case .failure(let error):
                    debugPrint("Error: \(error.localizedDescription)")
                }
            } receiveValue: { user in
                self.userInformation.send(user.response?.first)
            }
            .store(in: &cancellables)
    }
    
    private func fetchFriendInformation(requests: URLRequest...) -> AnyPublisher<[FriendInformation], Never> {
        guard !requests.isEmpty else {
            return Just([]).eraseToAnyPublisher()
        }
        
        let publishers = requests.map { request in
            apiManager.operateRequestReturnDataTaskPublisher(request: request, type: Friends.self)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { results in
                results.flatMap { $0.response }
            }
            .catch { _ in Just([]) }
            .eraseToAnyPublisher()
    }
    
    private func fetchFriendInformationWithoutInvitationAndFriends() {
        guard let request4 = apiManager.createRequest(url: APIEndpoints.fetchFriend4) else {
            return }
        
        fetchFriendInformation(requests: request4)
            .sink { [weak self] friends in
                guard let self = self, !friends.isEmpty else { return }
                self.friendInformation = friends
                self.friendTableViewDataSourcePublisher.send(self.friendInformation)
            }
            .store(in: &cancellables)
    }
    
    private func fetchFriendInformationWithoutInvitation() {
        guard let request1 = apiManager.createRequest(url: APIEndpoints.fetchFriend1),
              let request2 = apiManager.createRequest(url: APIEndpoints.fetchFriend2) else {
            return }
        
        fetchFriendInformation(requests: request1, request2)
            .sink { [weak self] friends in
                guard let self = self, !friends.isEmpty else { return }
                self.friendInformation = mergeFriendInformation(friends: friends)
                self.friendTableViewDataSourcePublisher.send(self.friendInformation)
            }
            .store(in: &cancellables)
    }
    
    private func fetchFriendInformationWithInvitation() {
        guard let request3 = apiManager.createRequest(url: APIEndpoints.fetchFriend3) else {
            return }
        
        fetchFriendInformation(requests: request3)
            .sink { [weak self] friends in
                guard let self = self, !friends.isEmpty else { return }
                self.friendInformation = friends
                self.friendTableViewDataSourcePublisher.send(self.friendInformation.filter { $0.status == 1 || $0.status == 2 })
                self.invitationTableViewDataSourcePublisher.send(self.friendInformation.filter { $0.status == 0 })
            }
            .store(in: &cancellables)
    }
    
    private func mergeFriendInformation(friends: [FriendInformation]) -> [FriendInformation] {
        var tempDict = [String: FriendInformation]()
        
        for friend in friends {
            var updatedFriend = friend
            updatedFriend.updateDate = friend.updateDate.replacingOccurrences(of: "/", with: "")
            if tempDict.contains(where: { $0.key == friend.name }) {
                guard let existingFriend = tempDict[friend.name],
                      let existingDate = dateFormatter.date(from: existingFriend.updateDate),
                      let newDate = dateFormatter.date(from: updatedFriend.updateDate),
                      newDate > existingDate else { continue }
                tempDict[friend.name] = updatedFriend
            } else {
                tempDict[friend.name] = updatedFriend
            }
        }
        return Array(tempDict.values)
    }
    
    private func searchFriendInformation(text: String) {
        var searchedData = [FriendInformation]()
        if text.isEmpty {
            searchedData = friendInformation.filter { $0.status != 0 }
        } else {
            searchedData = friendInformation
                .filter { $0.status != 0 }
                .filter { $0.name.contains(text) }
        }
        friendTableViewDataSourcePublisher.send(searchedData)
    }
}
