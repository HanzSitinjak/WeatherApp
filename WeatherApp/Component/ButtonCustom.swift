import UIKit

class ButtonCustomView: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.5
            self.setTitleColor(isEnabled ? .white : .lightGray, for: .normal)
        }
    }
    
    var titleBtn: String? {
        didSet {
            self.setTitle(titleBtn, for: .normal)
        }
    }
    
    var fontColor: UIColor? {
        didSet{
            if let color = fontColor{
                self.setTitleColor(color, for: .normal)
                self.setTitleColor(color.withAlphaComponent(0.5), for: .disabled)
            }
        }
    }
    
    var colorBtn: UIColor? {
        didSet {
            self.backgroundColor = colorBtn
        }
    }
    
    var widthBtn: CGFloat = 0 {
        didSet {
            self.frame.size.width = widthBtn
        }
    }
    
    var heightBtn: CGFloat = 0 {
        didSet {
            self.frame.size.height = heightBtn
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = 8
    }
}
