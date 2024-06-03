import UIKit
import SnapKit
import Combine
import CombineCocoa

class SelectStateViewController: UIViewController {
    
    // MARK: - Init
    
    // MARK: - Element
    lazy var noFriendButton: UIButton = {
        let v = UIButton()
        v.setTitle("No Friend", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 24
        return v
    }()
    
    lazy var friendsWithoutInvitationsButton: UIButton = {
        let v = UIButton()
        v.setTitle("Friends Without Invitation", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 24
        return v
    }()
    
    lazy var friendsWithInvitationsButton: UIButton = {
        let v = UIButton()
        v.setTitle("Friends With Invitations", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 24
        return v
    }()
    
    lazy var buttonStack: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fillEqually
        v.alignment = .fill
        v.spacing = 16
        v.addArrangedSubview(noFriendButton)
        v.addArrangedSubview(friendsWithoutInvitationsButton)
        v.addArrangedSubview(friendsWithInvitationsButton)
        return v
    }()
    
    // MARK: - Property
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initializeView()
        subviewLayout()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noFriendButton.setupGradientLayer([UIColor(rgb:0x56b30b).cgColor,
                                           UIColor(rgb: 0xa6cc42).cgColor],
                                          startPoint: CGPoint(x: 0, y: 0),
                                          endPoint: CGPoint(x: 1, y: 1))
        
        friendsWithoutInvitationsButton.setupGradientLayer([UIColor(rgb:0x56b30b).cgColor,
                                                            UIColor(rgb: 0xa6cc42).cgColor],
                                                           startPoint: CGPoint(x: 0, y: 0),
                                                           endPoint: CGPoint(x: 1, y: 1))
        
        friendsWithInvitationsButton.setupGradientLayer([UIColor(rgb:0x56b30b).cgColor,
                                                         UIColor(rgb: 0xa6cc42).cgColor],
                                                        startPoint: CGPoint(x: 0, y: 0),
                                                        endPoint: CGPoint(x: 1, y: 1))
    }
    
    private func initializeView() {
        view.addSubview(buttonStack)
    }
    
    private func subviewLayout() {
        buttonStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(164)
        }
    }
    
    private func bind() {
        noFriendButton.tapPublisher
            .sink { _ in
                self.navigationController?.pushViewController(
                    FriendViewController(state: .noFriends),
                    animated: true)
            }
            .store(in: &cancellables)
        
        friendsWithoutInvitationsButton.tapPublisher
            .sink { _ in
                self.navigationController?.pushViewController(
                    FriendViewController(state: .friendsWithoutInvitations),
                    animated: true)
            }
            .store(in: &cancellables)
        
        friendsWithInvitationsButton.tapPublisher
            .sink { _ in
                self.navigationController?.pushViewController(
                    FriendViewController(state: .friendsWithInvitations),
                    animated: true)
            }
            .store(in: &cancellables)
        
        
    }
}
