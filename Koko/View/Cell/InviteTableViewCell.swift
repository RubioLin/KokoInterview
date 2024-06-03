import UIKit
import SnapKit

class InviteTableViewCell: UITableViewCell {
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        self.selectedBackgroundView = selectedBackgroundView
        initializeView()
        subviewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Element
    lazy var baseView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 6
        v.layer.shadowColor = UIColor(rgb: 0x000000, alpha: 0.1).cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        v.layer.shadowOpacity = 1
        return v
    }()
    
    lazy var avatarIcon: UIImageView = {
        return UIImageView(image: UIImage(named: "imgFriendsList"))
    }()
    
    lazy var nameLabel: UILabel = {
        let v = UILabel()
        v.text = "測試"
        v.textColor = UIColor(rgb: 0x474747)
        v.font = UIFont(name: "PingFangTC-Regular", size: 16)
        return v
    }()
    
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "邀請你成為好友：）"
        v.textColor = UIColor(rgb: 0x999999)
        v.font = UIFont(name: "PingFangTC-Regular", size: 13)
        return v
    }()
    
    lazy var agreeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        return v
    }()
    
    lazy var deleteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "btnFriendsDelete"), for: .normal)
        return v
    }()
    
    // MARK: - Property
    
    // MARK: - Method
    private func initializeView() {
        contentView.addSubview(baseView)
        baseView.addSubviews(avatarIcon,
                             nameLabel,
                             descriptionLabel,
                             agreeButton,
                             deleteButton)
    }
    
    private func subviewLayout() {
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(30)
        }
        
        baseView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }

        avatarIcon.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(15)
            $0.width.equalTo(avatarIcon.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(avatarIcon.snp.right).offset(15)
            $0.top.equalToSuperview().inset(14)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.left.equalTo(avatarIcon.snp.right).offset(15)
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(15)
            $0.width.equalTo(agreeButton.snp.height)
        }
        
        agreeButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.right.equalTo(deleteButton.snp.left).offset(-15)
            $0.width.equalTo(agreeButton.snp.height)
        }
    }
    
    func config(friendInformation: FriendInformation) {
        nameLabel.text = friendInformation.name
    }
    
}
