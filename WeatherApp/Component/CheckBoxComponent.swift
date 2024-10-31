//
//  CheckBoxComponent.swift
//  WeatherApp
//
//  Created by Aleph-AHV2D on 09/10/24.
//

import Foundation
import UIKit

class CheckBoxComponent: UIButton {
    
    // Menyimpan status checkbox
    private var isChecked: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    // Closure untuk aksi saat status checkbox berubah
    var onCheckedChanged: ((Bool) -> Void)?
    
    // Inisialisasi dengan frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // Inisialisasi dengan NSCoder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // Setup awal checkbox
    private func setup() {
        self.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        updateAppearance()
    }
    
    // Fungsi untuk toggle status checkbox
    @objc private func toggle() {
        isChecked.toggle()
        onCheckedChanged?(isChecked) // Memanggil closure saat status berubah
    }
    
    // Memperbarui tampilan checkbox (checked/unchecked)
    private func updateAppearance() {
        if isChecked {
            self.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal) // Kotak dengan centang
            self.tintColor = UIColor.systemBlue // Warna centang
        } else {
            self.setImage(UIImage(systemName: "square"), for: .normal) // Kotak kosong
            self.tintColor = UIColor(hex: "#9CE0FB")!
        }
    }
}
