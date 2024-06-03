import Foundation
import Combine

class FriendTableViewHeaderViewModel {
    
    // MARK: - Input & Output
    var input: Input!
    var output: Output!
    
    struct Input {
        let searchTextSubscriber: PassthroughSubject<String, Never>
        let removeSearchBarSubscriber: PassthroughSubject<Void, Never>
        let searchBarResignFirstResponderSubscriber: PassthroughSubject<Void, Never>
        let searchBarisFirstResponderSubscriber: PassthroughSubject<Void, Never>
        let cancelButtonClickedSubscriber: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let searchTextPublisher: AnyPublisher<String, Never>
        let removeSearchBarPublisher: AnyPublisher<Void, Never>
        let searchBarResignFirstResponderPublisher: AnyPublisher<Void, Never>
        let searchBarisFirstResponderPublisher: AnyPublisher<Void, Never>
        let cancelButtonClickedPublisher: AnyPublisher<Void, Never>
    }
    
    // MARK: - Property
    private var cancellables = Set<AnyCancellable>()
    private let searchTextPublisher = CurrentValueSubject<String, Never>("")
    private let removeSearchBarPublisher = CurrentValueSubject<Void, Never>(())
    private let searchBarResignFirstResponderPublisher = CurrentValueSubject<Void, Never>(())
    private let searchBarisFirstResponderPublisher = CurrentValueSubject<Void, Never>(())
    private let cancelButtonClickedPublisher = CurrentValueSubject<Void, Never>(())
    
    // MARK: - Init
    init() {
        // Input
        let searchTextSubscriber = PassthroughSubject<String, Never>()
        searchTextSubscriber
            .compactMap { $0 }
            .subscribe(searchTextPublisher)
            .store(in: &cancellables)
        
        let removeSearchBarSubscriber = PassthroughSubject<Void, Never>()
        removeSearchBarSubscriber
            .subscribe(removeSearchBarPublisher)
            .store(in: &cancellables)
        
        let searchBarResignFirstResponderSubscriber = PassthroughSubject<Void, Never>()
        searchBarResignFirstResponderSubscriber
            .subscribe(searchBarResignFirstResponderPublisher)
            .store(in: &cancellables)
        
        let searchBarisFirstResponderSubscriber = PassthroughSubject<Void, Never>()
        searchBarisFirstResponderSubscriber
            .subscribe(searchBarisFirstResponderPublisher)
            .store(in: &cancellables)
        
        let cancelButtonClickedSubscriber =  PassthroughSubject<Void, Never>()
        cancelButtonClickedSubscriber
            .subscribe(cancelButtonClickedPublisher)
            .store(in: &cancellables)
        
        input = Input(searchTextSubscriber: searchTextSubscriber,
                      removeSearchBarSubscriber: removeSearchBarSubscriber,
                      searchBarResignFirstResponderSubscriber: searchBarResignFirstResponderSubscriber,
                      searchBarisFirstResponderSubscriber: searchBarisFirstResponderSubscriber,
                      cancelButtonClickedSubscriber: cancelButtonClickedSubscriber)
        
        // Output
        
        output = Output(searchTextPublisher: searchTextPublisher.eraseToAnyPublisher(),
                        removeSearchBarPublisher: removeSearchBarPublisher.eraseToAnyPublisher(),
                        searchBarResignFirstResponderPublisher: searchBarResignFirstResponderPublisher.eraseToAnyPublisher(),
                        searchBarisFirstResponderPublisher: searchBarisFirstResponderPublisher.eraseToAnyPublisher(),
                        cancelButtonClickedPublisher: cancelButtonClickedPublisher.eraseToAnyPublisher())
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Method

}
