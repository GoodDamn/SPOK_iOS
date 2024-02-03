//
//  SettingsViewController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import UIKit

class SettingsViewController
    : StackViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor
            .background()
        
        let w = view.frame.width
        let h = view.frame.height
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.07
            )
        targetClose(
            btnClose
        )
        
        let stackView = UIStackView(
            frame: CGRect(
                x: 0,
                y: h*0.4,
                width: w,
                height: h
            )
        )
        
        
        view.addSubview(btnClose)
    }
    
}
