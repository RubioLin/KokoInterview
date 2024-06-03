import UIKit
import SnapKit

class NoFriendView: UIView {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    // MARK: - Element
    lazy var friendsEmptyImage: UIImageView = {
        let v = UIImageView(image: UIImage(named: "imgFriendsEmpty"))
        return v
    }()
    
    lazy var sloganLabel: UILabel = {
        let v = UILabel()
        v.text = "就從加好友開始吧：）"
        v.textColor = UIColor(rgb: 0x474747)
        v.textAlignment = .center
        v.font = UIFont(name: "PingFangTC-Medium", size: 21)
        return v
    }()
    
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）"
        v.textColor = UIColor(rgb: 0x999999)
        v.textAlignment = .center
        v.font = UIFont(name: "PingFangTC-Regular", size: 14)
        v.numberOfLines = 0
        return v
    }()
    
    lazy var addFriendButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("加好友", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy var setupKokoIdLabel: UILabel = {
        let v = UILabel()
        let attributedString = NSMutableAttributedString(string: "幫助好友更快找到你？設定 KOKO ID")
        let pinkRange = (attributedString.mutableString as NSString).range(of: "設定 KOKO ID")
        attributedString.addAttribute(.foregroundColor, value: UIColor(rgb: 0xec008e), range: pinkRange)
        attributedString.addAttribute(.underlineStyle, value: 1, range: pinkRange)
        v.attributedText = attributedString
        v.textAlignment = .center
        v.isUserInteractionEnabled = true
        v.font = UIFont(name: "PingFangTC-Regular", size: 13)
        return v
    }()
    
    // MARK: - Property
    
    // MARK: - Method
    override func layoutSubviews() {
        super.layoutSubviews()
        subviewLayout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addFriendButton.setupGradientLayer([UIColor(rgb:0x56b30b).cgColor,
                                            UIColor(rgb: 0xa6cc42).cgColor],
                                           startPoint: CGPoint(x: 0, y: 0),
                                           endPoint: CGPoint(x: 1, y: 1))
    }
    
    private func initializeView() {
        addSubviews(friendsEmptyImage,
                    sloganLabel,
                    descriptionLabel,
                    addFriendButton,
                    setupKokoIdLabel)
    }
    
    private func subviewLayout() {
        friendsEmptyImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.left.right.equalToSuperview().inset(65)
            $0.height.equalTo(friendsEmptyImage.snp.width).multipliedBy(0.7020408163)
        }
        
        sloganLabel.snp.makeConstraints {
            $0.top.equalTo(friendsEmptyImage.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(44)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(sloganLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(68)
        }
        
        addFriendButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(90)
            $0.height.equalTo(40)
        }
        
        setupKokoIdLabel.snp.makeConstraints {
            $0.top.equalTo(addFriendButton.snp.bottom).offset(36)
            $0.left.right.equalToSuperview().inset(44)
        }
        
    }
    
    private func bind() {
        
    }
    
}
