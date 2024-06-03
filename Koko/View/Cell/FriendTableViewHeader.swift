import UIKit
import SnapKit
import Combine
import CombineCocoa

class FriendTableViewHeader: UITableViewHeaderFooterView {

    // MARK: - Init
    init(viewModel: FriendTableViewHeaderViewModel, reuseIdentifier: String? = "FriendTableViewHeader") {
        self.viewModel = viewModel
        super.init(reuseIdentifier: reuseIdentifier)
        initializeView()
        subviewLayout()
        bind(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Element
    lazy var searchBar: UISearchBar = {
        let v = UISearchBar()
        v.searchBarStyle = .minimal
        v.placeholder = "想轉一筆給誰呢？"
        v.setValue("取消", forKey: "cancelButtonText")
        return v
    }()
    
    lazy var addFriendButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "icBtnAddFriends")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return v
    }()
    
    // MARK: - Property
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: FriendTableViewHeaderViewModel
    
    // MARK: - Method
    func initializeView() {
        contentView.addSubviews(searchBar,
                                addFriendButton)
    }
    
    func subviewLayout() {
        searchBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.right.equalTo(addFriendButton.snp.left).offset(-15)
        }
        
        addFriendButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
            $0.size.equalTo(24)
        }
        
    }
    
    private func bind(viewModel: FriendTableViewHeaderViewModel) {
        
        searchBar.searchButtonClickedPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.searchBar.resignFirstResponder()
            }
            .store(in: &cancellables)
        
        searchBar.cancelButtonClickedPublisher
            .subscribe(viewModel.input.cancelButtonClickedSubscriber)
            .store(in: &cancellables)
        
        searchBar.textDidChangePublisher
            .compactMap { $0 }
            .subscribe(viewModel.input.searchTextSubscriber)
            .store(in: &cancellables)
        
        searchBar.searchTextField.didBeginEditingPublisher
            .sink{ _ in
                self.searchBar.setShowsCancelButton(true, animated: true)
                self.viewModel.input.searchBarisFirstResponderSubscriber.send()
            }
            .store(in: &cancellables)
        
        viewModel.output.removeSearchBarPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                self.searchBar.text?.removeAll()
            }
            .store(in: &cancellables)
        
        viewModel.output.searchBarResignFirstResponderPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                self.searchBar.resignFirstResponder()
                self.searchBar.setShowsCancelButton(false, animated: true)
            }
            .store(in: &cancellables)
        
    }
}
