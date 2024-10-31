//
//  UIColor.swift
//  WeatherApp
//
//  Created by Aleph-AHV2D on 09/10/24.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var rgb: UInt64 = 0
        
        // Menghapus '#' jika ada
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard hexString.hasPrefix("#") else { return nil }
        
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        
        // Mengonversi string ke UInt64
        Scanner(string: hexColor).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

