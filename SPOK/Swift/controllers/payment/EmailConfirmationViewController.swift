//
//  EmailConfirmationViewController.swift
//  SPOK
//
//  Created by GoodDamn on 27/05/2024.
//

import Foundation
import UIKit

final class EmailConfirmationViewController
    : StatViewController {
    
    var onConfirmEmail: ((String) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background()
        
        let w = view.frame.width
        let h = view.frame.height
        
        let marginH = w * 0.13
        let marginTop = h * 0.1
        
        let labelEmail = UILabela(
            frame: CGRect(
                x: marginH,
                y: marginTop,
                width: w - marginH,
                height: 1
            )
        )
        
        let textEmail = UIEditText(
            frame: CGRect(
                x: marginH,
                y: 0,
                width: w - marginH*2,
                height: h * 0.08
            )
        )
        
        let textBtnConfirm = ViewUtils
            .textButton(
                text: "OK"
            )
        
        labelEmail.text = "Отправить чек на:"
        labelEmail.textColor = .white
        labelEmail.font = .bold(
            withSize: w * 0.08
        )
        
        labelEmail.sizeToFit()
        
        textEmail.autocapitalizationType = .none
        textEmail.placeholder = "Email"
        textEmail.backgroundColor = .background()
        textEmail.textColor = .white
        textEmail.layer.borderColor = UIColor.white.cgColor
        textEmail.layer.borderWidth = textEmail.height() * 0.01
        
        textEmail.corner(
            normHeight: 0.25
        )
        
        LayoutUtils.textButton(
            for: textBtnConfirm,
            size: view.frame.size,
            textSize: 0.024,
            paddingHorizontal: 0.3,
            paddingVertical: 0.038
        )
        
        labelEmail.centerH(
            in: view
        )
        
        textEmail.frame.origin.y =
            labelEmail.bottomy() +
            labelEmail.height() * 0.5
        
        textBtnConfirm.frame.origin.y =
            textEmail.bottomy() +
            textEmail.height() * 0.5
        
        textBtnConfirm.centerH(
            in: view
        )
        
        textBtnConfirm.corner(
            normHeight: 0.35
        )
        
        view.addSubview(
            textEmail
        )
        
        view.addSubview(
            labelEmail
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
