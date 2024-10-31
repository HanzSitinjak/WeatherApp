import UIKit

class ContainerCustom: UIView {

    // Custom initializer yang menerima tinggi dan border radius
    init(height: CGFloat, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        
        // Set up properties
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        // Set background color
        self.backgroundColor = .lightGray
        
        // Atur sudut melengkung
        setupCorners(cornerRadius: cornerRadius)
    }

    // Implementasi untuk Storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Set default values untuk properti
        self.backgroundColor = .white
        
        // Jika ingin mengatur sudut melengkung dari Storyboard, gunakan setupCorners
        setupCorners(cornerRadius: 20) // Misalnya, 20 jika tidak ada yang ditentukan
    }

    // Fungsi untuk mengatur sudut melengkung
    private func setupCorners(cornerRadius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    // Override layoutSubviews untuk memperbarui sudut saat ukuran view berubah
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCorners(cornerRadius: 25) // Ubah jika ingin menggunakan cornerRadius yang bisa disesuaikan
    }
}
