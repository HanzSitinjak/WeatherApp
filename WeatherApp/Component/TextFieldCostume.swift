//
//  TextFieldCostume.swift
//  WeatherApp
//
//  Created by Aleph-AHV2D on 09/10/24.
//

import Foundation
import UIKit

class TextFieldCostume: UITextField, UITextFieldDelegate{
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect)->CGRect{
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.delegate = self
//        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
//        setup()
    }
    
    func setProperty(fontColor: UIColor,borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, placeholder: String){
        self.textColor = fontColor
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: borderColor]
        )
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false}
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 10
        
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted
        let filtered = string.components(separatedBy: characterSet)
        
        if filtered.count > 1{
            return false
        }
    }
}
