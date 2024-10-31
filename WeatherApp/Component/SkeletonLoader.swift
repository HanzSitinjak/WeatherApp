import UIKit

extension UIView {
    func startSkeletonAnimation() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0.4, alpha: 1).cgColor,   // Warna abu-abu lebih gelap
            UIColor(white: 0.6, alpha: 1).cgColor,   // Warna abu-abu lebih terang
            UIColor(white: 0.4, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 10
        gradientLayer.masksToBounds = true  // Agar rapi di tepinya

        // Animasi efek ombak
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -self.bounds.width
        animation.toValue = self.bounds.width
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "skeletonAnimation")
        self.layer.addSublayer(gradientLayer)
    }

    func stopSkeletonAnimation() {
        // Menghapus semua lapisan gradient yang ada
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
    }
}
