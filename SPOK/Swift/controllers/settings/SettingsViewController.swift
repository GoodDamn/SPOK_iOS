//
//  SettingsViewController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import UIKit

class SettingsViewController
    : SignInAppleController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor
            .background()
        
        let w = view.frame.width
        let h = view.frame.height
        
        let hbtnDelete = h * 0.1
        
        
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
        
        let btnDelete = UIButton(
            frame: CGRect(
                x: 0,
                y: h-hbtnDelete,
                width: w,
                height: hbtnDelete
            )
        )
        
        btnDelete.setTitleColor(
            .systemRed,
            for: .normal
        )
        
        btnDelete.setTitle(
            "Удалить аккаунт",
            for: .normal
        )
        
        btnDelete.addTarget(
            self,
            action: #selector(
                onClickBtnDelete(_:)
            ),
            for: .touchUpInside
        )
        
        view.addSubview(btnClose)
        view.addSubview(btnDelete)
    }
    
    @objc func onClickBtnDelete(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
       
        signIn()
        
    }
    
    
    
}
