import UIKit

class FriendViewController: UIViewController {
    
    // MARK: - Init
    init(state: FriendState) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Element
    private var ownView: FriendView!
    
    // MARK: - Property
    private let state: FriendState
    
    // MARK: - Method
    override func loadView() {
        super.loadView()
        setupOwnView()
    }
    
    private func setupOwnView() {
        let viewModel = FriendViewModel(state: state)
        ownView = FriendView(viewModel: viewModel)
        ownView.delegate = self
        view = ownView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = ownView.icNavPinkScanBarButton
        
        navigationItem.leftBarButtonItems = [
            ownView.icNavPinkWithdrawBarButton,
            ownView.icNavPinkTransferBarButton]
    }
}

extension FriendViewController: FriendViewControllerDelegate {
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}

enum FriendState {
    case noFriends
    case friendsWithoutInvitations
    case friendsWithInvitations
}
