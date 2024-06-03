import UIKit
import SnapKit
import Combine
import CombineCocoa

protocol FriendViewControllerDelegate: AnyObject {
    func popToRootViewController()
}

class FriendView: UIView {
    
    // MARK: - Init
    init(viewModel: FriendViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = UIColor(rgb: 0xfcfcfc)
        bind(viewModel: viewModel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Element
    lazy var icNavPinkWithdrawBarButton: UIBarButtonItem = {
        let image = UIImage(named: "icNavPinkWithdraw")?.withRenderingMode(.alwaysOriginal)
        let v = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
         return v
    }()
    
    lazy var icNavPinkTransferBarButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: UIImageView(image: UIImage(named: "icNavPinkTransfer")))
    }()
    
    lazy var icNavPinkScanBarButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: UIImageView(image: UIImage(named: "icNavPinkScan")))
    }()
    
    lazy var topView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var avatarIcon: UIImageView = {
        return UIImageView(image: UIImage(named: "imgFriendsFemaleDefault"))
    }()
    
    lazy var nameLabel: UILabel = {
        let v = UILabel()
        v.text = "測試"
        v.textColor = UIColor(rgb: 0x474747)
        v.font = UIFont(name: "PingFangTC-Medium", size: 17)
        return v
    }()
    
    lazy var idLabel: UILabel = {
        let v = UILabel()
        v.text = "設定 KOKO ID"
        v.textColor = UIColor(rgb: 0x474747)
        v.font = UIFont(name: "PingFangTC-Regular", size: 13)
        return v
    }()
    
    lazy var switchView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var friendBadgeView: BadgeView = {
        let v = BadgeView(title: "好友")
        v.bottomLine.isHidden = false
        return v
    }()
    
    lazy var chatBadgeView: BadgeView = {
        let v = BadgeView(title: "聊天")
        return v
    }()
    
    lazy var separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(rgb: 0xefefef)
        return v
    }()
    
    lazy var noFriendView: NoFriendView = {
        let v = NoFriendView()
        return v
    }()
    
    lazy var friendTableView: UITableView = {
        let v = UITableView()
        v.delegate = self
        v.separatorInset = UIEdgeInsets(top: 0, left: 85, bottom: 0, right: 10)
        v.refreshControl = refreshControl
        if #available(iOS 15.0, *) {
            v.sectionHeaderTopPadding = 0
        }
        v.register(FriendTableViewCellWithStatus1.self,
                   forCellReuseIdentifier: "FriendTableViewCellWithStatus1")
        v.register(FriendTableViewCellWithStatus2.self,
                   forCellReuseIdentifier: "FriendTableViewCellWithStatus2")
        return v
    }()
    
    lazy var inviteTableView: UITableView = {
        let v = UITableView()
        v.delegate = self
        v.backgroundColor = .white
        v.separatorStyle = .none
        if #available(iOS 15.0, *) {
            v.sectionHeaderTopPadding = 0
        }
        v.register(InviteTableViewCell.self,
                   forCellReuseIdentifier: "InviteTableViewCell")
        return v
    }()
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - Property
    weak var delegate: FriendViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: FriendViewModel
    private let friendTableViewHeaderViewModel = FriendTableViewHeaderViewModel()
    lazy private var friendsDataSource: UITableViewDiffableDataSource<FriendsSection, FriendInformation> = {
        return UITableViewDiffableDataSource<FriendsSection, FriendInformation>(tableView: friendTableView) { tableView, indexPath, item in
            if item.status == 1 {
                guard let cellWithStatus1 = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCellWithStatus1", for: indexPath) as? FriendTableViewCellWithStatus1 else { return UITableViewCell() }
                cellWithStatus1.config(friendInformation: item)
                return cellWithStatus1
            } else {
                guard let cellWithStatus2 = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCellWithStatus2", for: indexPath) as? FriendTableViewCellWithStatus2 else { return UITableViewCell() }
                cellWithStatus2.config(friendInformation: item)
                return cellWithStatus2
            }
        }
    }()
    lazy private var invitationDataSource: UITableViewDiffableDataSource<FriendsSection, FriendInformation> = {
        return UITableViewDiffableDataSource<FriendsSection, FriendInformation>(tableView: inviteTableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteTableViewCell", for: indexPath) as? InviteTableViewCell else { return UITableViewCell() }
            cell.config(friendInformation: item)
            return cell
        }
    }()
    
    // MARK: - Method
    private func initializeView(state: FriendState) {
        topView.addSubviews(avatarIcon,
                            nameLabel,
                            idLabel)
        
        switchView.addSubviews(friendBadgeView,
                               chatBadgeView)
        switch state {
        case .noFriends:
            addSubviews(topView,
                        switchView,
                        separatorLine,
                        noFriendView)
        case .friendsWithoutInvitations:
            addSubviews(topView,
                        switchView,
                        separatorLine,
                        friendTableView)
        case .friendsWithInvitations:
            addSubviews(topView,
                        inviteTableView,
                        switchView,
                        separatorLine,
                        friendTableView)
        }
    }
    
    private func subviewLayout(state: FriendState) {
        topView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(snp.height).multipliedBy(0.11994003)
        }
        
        avatarIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.right.equalToSuperview().inset(30)
            $0.height.equalToSuperview().multipliedBy(0.675)
            $0.width.equalTo(avatarIcon.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(30)
            $0.right.equalTo(avatarIcon.snp.left)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(30)
        }
        
        switchView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(snp.height).multipliedBy(0.07196401799)
        }
        
        friendBadgeView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(30)
            $0.top.bottom.equalToSuperview()
        }
        
        chatBadgeView.snp.makeConstraints {
            $0.left.equalTo(friendBadgeView.snp.right).offset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(switchView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        switch state {
        case .noFriends:
            noFriendView.snp.makeConstraints {
                $0.top.equalTo(separatorLine.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
            }
        case .friendsWithoutInvitations:
            friendTableView.snp.makeConstraints {
                $0.top.equalTo(separatorLine.snp.bottom)
                $0.bottom.equalToSuperview()
                $0.left.right.equalToSuperview().inset(20)
            }
        case .friendsWithInvitations:
            inviteTableView.snp.makeConstraints {
                $0.top.equalTo(topView.snp.bottom)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(snp.height).multipliedBy(0.263868066)
            }
            
            switchView.snp.remakeConstraints {
                $0.top.equalTo(inviteTableView.snp.bottom)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(snp.height).multipliedBy(0.07196401799)
            }
            
            friendTableView.snp.makeConstraints {
                $0.top.equalTo(separatorLine.snp.bottom)
                $0.bottom.equalToSuperview()
                $0.left.right.equalToSuperview().inset(20)
            }
        }
        
    }
    
    private func bind(viewModel: FriendViewModel) {
        icNavPinkWithdrawBarButton.tapPublisher
            .sink { [weak self] _ in
                self?.delegate?.popToRootViewController()
            }
            .store(in: &cancellables)
        
        refreshControl.isRefreshingPublisher
            .sink { isRefreshing in
                guard isRefreshing else { return }
                self.friendTableViewHeaderViewModel.input.removeSearchBarSubscriber.send()
                viewModel.input.isRefreshingSubscriber.send()
            }
            .store(in: &cancellables)
        
        // Output
        viewModel.output.currentState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.initializeView(state: state)
                self?.subviewLayout(state: state)
                switch state {
                case .noFriends:
                    self?.friendBadgeView.config(badge: 0)
                    self?.chatBadgeView.config(badge: 0)
                case .friendsWithoutInvitations:
                    self?.friendBadgeView.config(badge: 0)
                    self?.chatBadgeView.config(badge: 100)
                case .friendsWithInvitations:
                    self?.friendBadgeView.config(badge: 2)
                    self?.chatBadgeView.config(badge: 100)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.userInformation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let user = user else { return }
                self?.nameLabel.text = user.name
                self?.idLabel.text = "KOKO ID：" + (user.kokoid ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.output.friendTableViewDataSourcePublisher
            .receive(on: DispatchQueue.main)
            .sink { friendsInformation in
                var snapshot = NSDiffableDataSourceSnapshot<FriendsSection, FriendInformation>()
                snapshot.appendSections([.friends])
                snapshot.appendItems(friendsInformation, toSection: .friends)
                self.friendsDataSource.apply(snapshot, animatingDifferences: false)
                self.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.output.invitationTableViewDataSourcePublisher
            .receive(on: DispatchQueue.main)
            .sink { friendsInformation in
                var snapshot = NSDiffableDataSourceSnapshot<FriendsSection, FriendInformation>()
                snapshot.appendSections([.friends])
                snapshot.appendItems(friendsInformation, toSection: .friends)
                self.invitationDataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
        
        viewModel.output.inviteTableViewIsFoldPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFold in
                self?.updateInviteTableViewLayout(isFold: isFold)
            }
            .store(in: &cancellables)
        
        // FriendTableViewHeaderViewModel
        friendTableViewHeaderViewModel.output.searchTextPublisher
            .subscribe(viewModel.input.searchTextSubscriber)
            .store(in: &cancellables)
        
        friendTableViewHeaderViewModel.output.searchBarisFirstResponderPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.updateFriendTableViewLayout()
            }
            .store(in: &cancellables)
        
        friendTableViewHeaderViewModel.output.cancelButtonClickedPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.friendTableViewHeaderViewModel.input.searchBarResignFirstResponderSubscriber.send()
                UIView.animate(withDuration: 0.5) {
                    self.topView.isHidden = false
                    self.friendTableView.snp.remakeConstraints {
                        $0.top.equalTo(self.separatorLine.snp.bottom)
                        $0.bottom.equalToSuperview()
                        $0.left.right.equalToSuperview().inset(20)
                    }
                    self.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateFriendTableViewLayout() {
        UIView.animate(withDuration: 0.5) {
            self.topView.isHidden = true
            self.friendTableView.snp.remakeConstraints {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                $0.bottom.equalToSuperview()
                $0.left.right.equalToSuperview().inset(20)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func updateInviteTableViewLayout(isFold: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.inviteTableView.snp.remakeConstraints {
                $0.top.equalTo(self.topView.snp.bottom)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(self.snp.height).multipliedBy(isFold ? 0.15 : 0.263868066)
            }
            self.layoutIfNeeded()
        }
        inviteTableView.isScrollEnabled = !isFold
    }
    
}

extension FriendView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == friendTableView {
            return FriendTableViewHeader(viewModel: friendTableViewHeaderViewModel)
        } else {
            let v = UIView()
            v.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer()
            tapGesture.tapPublisher
                .map { _ in }
                .subscribe(viewModel.input.inviteTableViewIsFoldSubscriber)
                .store(in: &cancellables)
            v.addGestureRecognizer(tapGesture)
            return v
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == friendTableView {
            return 60
        } else {
            return 25
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == friendTableView {
            return 60
        } else {
            return 80
        }
    }
    
}

extension FriendView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == friendTableView {
            friendTableViewHeaderViewModel.input.searchBarResignFirstResponderSubscriber.send()
        }
    }
}
