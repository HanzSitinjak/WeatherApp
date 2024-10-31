//
//  OnBoardingFirst.swift
//  WeatherApp
//
//  Created by Aleph-AHV2D on 09/10/24.
//

import Foundation
import UIKit

class OnBoardingFirstVC: ViewController{
//    var Container : ContainerCustom!
//
    
    @IBOutlet weak var buttonCustomOB1: ButtonCustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCustomOB1.fontColor = UIColor.white
        buttonCustomOB1.titleBtn = "Selanjutnya"
        buttonCustomOB1.colorBtn = UIColor(hex: "#9CE0FB")
        buttonCustomOB1.widthBtn = 340
        buttonCustomOB1.heightBtn = 60
        
        buttonCustomOB1.addTarget(self, action: #selector(btnOB1pressed), for: .touchUpInside)
    }
    
    @objc func btnOB1pressed(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let toOnBoarding2 = storyboard.instantiateViewController(withIdentifier: "onBoardingFinal")as?OnBoardingFinalVC{
            navigationController?.pushViewController(toOnBoarding2, animated: true)
        }
    }
}
