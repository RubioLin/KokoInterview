import UIKit
import SnapKit

class BadgeView: UIView {

    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    // MARK: - Element
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "好友"
        v.textColor = UIColor(rgb: 0x474747)
        v.textAlignment = .center
        v.font = UIFont(name: "PingFangTC-Medium", size: 13)
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var badgeLabel: PaddingLabel = {
        let v = PaddingLabel()
        v.text = "9"
        v.textColor = .white
        v.textAlignment = .center
        v.font = UIFont(name: "PingFangTC-Medium", size: 12)
        v.backgroundColor = UIColor(rgb: 0xf9b2dc)
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 9
        v.paddingLeft = 4
        v.paddingRight = 4
        return v
    }()
    
    lazy var bottomLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(rgb: 0xec008c)
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 2
        v.isHidden = true
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
        
    }
    
    private func initializeView() {
        addSubviews(titleLabel,
                    badgeLabel,
                    bottomLine)
    }
    
    private func subviewLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.left.equalToSuperview().inset(2)
        }
        
        badgeLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY).offset(-7)
            $0.left.equalTo(titleLabel.snp.right).offset(2)
            $0.right.equalToSuperview()
            $0.width.greaterThanOrEqualTo(18)
            $0.height.equalTo(18)
        }
        
        bottomLine.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left).offset(3)
            $0.right.equalTo(titleLabel.snp.right).offset(-3)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    func config(badge: Int) {
        guard badge > 0 else {
            badgeLabel.isHidden = true
            return }
        if badge >= 100 {
            badgeLabel.text = "99+"
        } else {
            badgeLabel.text = badge.description
        }
    }
}
