import UIKit
import SnapKit

class FriendTableViewCellWithStatus1: UITableViewCell {
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        subviewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Element
    lazy var friendStar: UIImageView = {
        let v = UIImageView(image: UIImage(named: "icFriendsStar"))
        v.isHidden = true
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
    
    lazy var transferButton: UIButton = {
        var v = UIButton()
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.titleAlignment = .center
            config.titlePadding = 20
            var title = AttributedString("轉帳")
            title.foregroundColor = UIColor(rgb: 0xec008c)
            title.font = UIFont(name: "PingFangTC-Medium", size: 14)
            config.attributedTitle = title
            v = UIButton(configuration: config)
        } else {
            v.setTitle("轉帳", for: .normal)
            v.setTitleColor(UIColor(rgb: 0xec008c), for: .normal)
            v.titleLabel?.textAlignment = .center
            v.titleLabel?.font = UIFont(name: "PingFangTC-Medium", size: 14)
            v.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        v.layer.borderColor = UIColor(rgb: 0xec008c).cgColor
        v.layer.borderWidth = 1.2
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 2
        return v
    }()
    
    lazy var moreButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "icFriendsMore"), for: .normal)
        return v
    }()
    
    // MARK: - Property
    
    // MARK: - Method
    private func initializeView() {
        contentView.addSubviews(friendStar,
                                avatarIcon,
                                nameLabel,
                                transferButton,
                                moreButton)
    }
    
    private func subviewLayout() {
        friendStar.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(23)
            $0.left.equalToSuperview().inset(10)
        }
        
        avatarIcon.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalTo(friendStar.snp.right).offset(6)
            $0.width.equalTo(avatarIcon.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(avatarIcon.snp.right).offset(15)
        }
        
        transferButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.right.equalTo(moreButton.snp.left).offset(-10)
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
            $0.size.equalTo(24)
        }
    }
    
    func config(friendInformation: FriendInformation) {
        nameLabel.text = friendInformation.name
        friendStar.isHidden = !(friendInformation.isTop == "1")
    }
}
