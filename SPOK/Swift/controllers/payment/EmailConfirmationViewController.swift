//
//  EmailConfirmationViewController.swift
//  SPOK
//
//  Created by GoodDamn on 27/05/2024.
//

import Foundation
import UIKit

final class EmailConfirmationViewController
    : UIViewController {
    
    var onConfirmEmail: ((String) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background()
        
        let w = view.frame.width
        let h = view.frame.height
        
        let textEmail = UITextField(
            frame: CGRect(
                x: 0,
                y: 0,
                width: w,
                height: h * 0.15
            )
        )
        
        let textBtnConfirm = ViewUtils
            .textButton(
                text: "OK"
            )
        
        textEmail.autocapitalizationType = .none
        textEmail.placeholder = "Email"
        textEmail.borderStyle = .roundedRect
        
        LayoutUtils.textButton(
            for: textBtnConfirm,
            size: view.frame.size,
            textSize: 0.027,
            paddingHorizontal: 0.3,
            paddingVertical: 0.05
        )
        
        textBtnConfirm.frame.origin.y =
            textEmail.frame.height
        
        textBtnConfirm.centerH(
            in: view
        )
        
        view.addSubview(
            textEmail
        )
        
        view.addSubview(
            textBtnConfirm
        )
        
        
        textBtnConfirm.onClick = { [weak self]
            v in
            self?.onConfirmEmail?(
                textEmail.text ?? ""
            )
            self?.dismiss(
                animated: true
            )
        }
        
    }
    
    
}
