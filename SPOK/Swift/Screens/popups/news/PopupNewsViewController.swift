//
//  PopupNews.swift
//  SPOK
//
//  Created by GoodDamn on 29/01/2024.
//

import Foundation
import UIKit

class PopupNewsViewController
    : StackViewController {
    
    var msgType: Int = 1
    var msgID: Int = -1
    var msgDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            named: "background"
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        let extraBold = UIFont(
            name: "OpenSans-ExtraBold",
            size: h * 0.05
        )
        
        let semiBold = UIFont(
            name: "OpenSans-SemiBold",
            size: h * 0.02
        )
        
        
        let mLeft = 0.1 * w
        let wcontent = w - mLeft*2
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.08
            )
        
        btnClose.addTarget(
            self,
            action: #selector(
                onClickBtnClose(_:)
            ),
            for: .touchUpInside
        )
        
        let lTitle = UILabela(
            frame: CGRect(
                x: mLeft,
                y: mInsets.top == 0 ?
                    h * 0.03
                    : mInsets.top,
                width: btnClose.frame.origin.x - mLeft,
                height: 1
            )
        )
        
        lTitle.text = title
        lTitle.font = extraBold
        lTitle.textColor = .white
        lTitle.backgroundColor = .clear
        lTitle.lineHeight = 0.83
        lTitle.numberOfLines = 0
        lTitle.attribute()
        
        lTitle.sizeToFit()
        
        let lDesc = UITextView(
            frame: CGRect(
                x: mLeft,
                y: lTitle.frame.bottom(),
                width: lTitle.frame.width,
                height: h - lTitle.frame.bottom()
            )
        )
        
        lDesc.isScrollEnabled = true
        lDesc.text = msgDescription
        lDesc.font = semiBold
        lDesc.textColor = .white
        lDesc.backgroundColor = .clear
        
        view.addSubview(lTitle)
        view.addSubview(lDesc)
        view.addSubview(btnClose)
        
        
        if msgType <= 1 {
            let btnOk = ViewUtils
                .button(
                    text: "Хорошо"
                )
            LayoutUtils
                .button(
                    for: btnOk,
                    view.frame,
                    y: 0,
                    width: 0.7,
                    height: 0.1,
                    textSize: 0.35
                )
            
            view.addSubview(
                btnOk
            )
        }
        
        if msgType >= 1 && msgType <= 2 {
            let btnUpdate = ViewUtils
                .button(
                    text: "Обновить приложение"
                )
            
            LayoutUtils
                .button(
                    for: btnUpdate,
                    view.frame,
                    y: 0,
                    width: 0.7,
                    height: 0.1,
                    textSize: 0.3
                )
            
            let v = view.subviews[ // >= 3
                view.subviews.count - 1
            ]
            
            let wb = (v as? UIButton)?.frame.height ?? 0
            let mBottom = h * 0.04
            
            btnUpdate.frame.origin.y =
                h - wb + mBottom + btnUpdate.frame.height
            
            view.addSubview(
                btnUpdate
            )
        }
        
        
    }
    
    
    private func markAsRead() {
        let def = UserDefaults.standard
        def.setValue(
            msgID,
            forKey: KeyUtils.mIdNews
        )
    }
}
