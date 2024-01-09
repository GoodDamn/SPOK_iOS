//
//  ProfileNewViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class ProfileNewViewController
    : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .fullScreen
        
        let w = view.frame.width
        let h = view.frame.height
        
        let marginTop = h * 0.08
        let marginLeft = w * 0.05
        
        let lTitle = UILabel(
            frame: CGRect(
                x: marginTop,
                y: marginLeft,
                width: w,
                height: w * 0.05
            )
        )
        
        lTitle.text = "Профиль"
        lTitle.textColor = .white
        lTitle.font = UIFont(
            name: "OpenSans-ExtraBold",
            size: lTitle.frame.height
        )
        
        view.addSubview(lTitle)
    }
}
