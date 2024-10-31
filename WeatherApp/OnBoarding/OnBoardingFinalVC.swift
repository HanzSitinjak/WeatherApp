//
//  OnBoardingFinal.swift
//  WeatherApp
//
//  Created by Aleph-AHV2D on 09/10/24.
//

import Foundation
import UIKit

class OnBoardingFinalVC: ViewController{
    @IBOutlet weak var textFieldUsername: TextFieldCostume!
    
    @IBOutlet weak var CheckBoxSet: CheckBoxComponent!
    
    @IBOutlet weak var alertInputUser: UILabel!
    
    
    @IBOutlet weak var buttonAccessHome: ButtonCustomView!
    
    var isCheckBoxChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ini untuk textfield
        textFieldUsername.frame.size.height = 50
        textFieldUsername.setProperty(
            fontColor: UIColor(hex: "#9CE0FB")!,
            borderWidth: 1.0,
            borderColor: UIColor(hex: "#9CE0FB")!,
            cornerRadius: 16.0,
            placeholder: "Tuliskan Username Disini."
        )
        textFieldUsername.delegate = textFieldUsername
        
        alertInputUser.isHidden = true
        
        //Untuk CheckBox
        CheckBoxSet.onCheckedChanged = { isChecked in
            if isChecked {
                print("Checkbox is checked!")
            } else {
                print("Checkbox is unchecked!")
            }
        }
        
        //ButtonToHome
        buttonAccessHome.fontColor = UIColor.white
        buttonAccessHome.titleBtn = "Selesai"
        buttonAccessHome.colorBtn = UIColor(hex: "#9CE0FB")
        buttonAccessHome.widthBtn = 340
        buttonAccessHome.heightBtn = 60
        
        buttonAccessHome.addTarget(self, action: #selector(accessHomePressed), for: .touchUpInside)
        
        CheckBoxSet.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        updateButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "homePage"{
            if let toHomePage = segue.destination as? homePageVC{
                toHomePage.username = textFieldUsername.text
            }
        }
    }
    
    @objc private func checkBoxTapped(){
        isCheckBoxChecked.toggle()
        updateButtonState()
    }
    
    @IBAction private func accessHomePressed(){
        validateUsername()
        
        if let username = textFieldUsername.text, username.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%^&*()")) == nil{
            print("username yang di input \(username)")
        }
    }
    
    private func updateButtonState(){
        if isCheckBoxChecked{
            buttonAccessHome.isEnabled = true
            buttonAccessHome.colorBtn = UIColor(hex: "#9CE0FB")!
            buttonAccessHome.setTitleColor(.white, for: .normal)
        }else{
            buttonAccessHome.isEnabled = false
            buttonAccessHome.colorBtn = UIColor.lightGray
            buttonAccessHome.setTitleColor(.white, for: .normal)
        }
    }

    
    private func validateUsername(){
        guard let username = textFieldUsername.text, !username.isEmpty else {
            alertInputUser.text = "Username tidak boleh kosong!"
            alertInputUser.textColor = .red
            alertInputUser.isHidden = false
            textFieldUsername.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        if let username = textFieldUsername.text, username.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%^&*()")) != nil{
            textFieldUsername.textColor = UIColor .red
            textFieldUsername.layer.borderColor = UIColor.red.cgColor
            alertInputUser.text = "Username Tidak Valid!"
            alertInputUser.textColor = .red
            alertInputUser.isHidden = false
        }else if isCheckBoxChecked{
            alertInputUser.isHidden = true
            textFieldUsername.layer.backgroundColor = UIColor.clear.cgColor
            textFieldUsername.textColor = UIColor(hex: "#9CE0FB")!
            textFieldUsername.layer.borderColor = UIColor(hex: "#9CE0FB")!.cgColor
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let toHomePage = storyboard.instantiateViewController(withIdentifier: "homePage")as?homePageVC{
                navigationController?.pushViewController(toHomePage, animated: true)
                toHomePage.username = username
            }
        }else{
            textFieldUsername.layer.backgroundColor = UIColor.clear.cgColor
            textFieldUsername.textColor = UIColor(hex: "#9CE0FB")!
            textFieldUsername.layer.borderColor = UIColor(hex: "#9CE0FB")!.cgColor
            alertInputUser.isHidden = true
        }
    }
}

