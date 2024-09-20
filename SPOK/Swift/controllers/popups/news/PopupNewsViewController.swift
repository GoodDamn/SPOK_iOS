//
//  PopupNews.swift
//  SPOK
//
//  Created by GoodDamn on 29/01/2024.
//

import Foundation
import UIKit
import StoreKit

final class PopupNewsViewController
    : StackViewController {
    
    var msgType: Int = 0
    var msgID: Int = -1
    var msgDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background()
        
        let w = view.width()
        let h = view.height()
        
        let extraBold = UIFont.extrabold(
            withSize: h * 0.05
        )
        
        let semiBold = UIFont.semibold(
            withSize: h * 0.02
        )
        
        let mLeft = 0.08 * w
        
        let btnClose = ViewUtils.buttonClose(
            in: view,
            sizeSquare: 0.16
        )
        
        btnClose.onClick = { [weak self] view in
            self?.onClickBtnClose(
                view
            )
        }
        
        let lTitle = UILabela(
            frame: CGRect(
                x: mLeft,
                y: mInsets.top == 0 ?
                    h * 0.07
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
        lDesc.isUserInteractionEnabled = false
        
        view.addSubview(lTitle)
        view.addSubview(lDesc)
        
        let mBottom = h * 0.04 + mInsets.bottom
        
        if msgType <= 1 {
            
            view.addSubview(btnClose)
            
            let btnOk = ViewUtils
                .textButton(
                    text: "Хорошо"
                )
            
            LayoutUtils.textButton(
                for: btnOk,
                size: view.frame.size,
                textSize: 0.02,
                paddingHorizontal: 0.2,
                paddingVertical: 0.04
            )
            
            btnOk.frame.origin.y =
                h - btnOk.height() - mBottom
            
            btnOk.centerH(
                in: view
            )
            
            btnOk.onClick = { [weak self] view in
                self?.onClickBtnClose(
                    view
                )
            }
            
            view.addSubview(
                btnOk
            )
        }
        
        if !(msgType >= 1 && msgType <= 2) {
            return
        }
        
        let btnUpdate = ViewUtils.textButton(
            text: "Обновить приложение"
        )
        
        LayoutUtils.textButton(
            for: btnUpdate,
            size: view.frame.size,
            textSize: 0.02,
            paddingHorizontal: 0.2,
            paddingVertical: 0.04
        )
        
        btnUpdate.centerH(
            in: view
        )
        
        let v = view.subviews[ // >= 3
            view.subviews.count - 1
        ]
        
        let yyyy = v.frame.y()
        
        let yb = yyyy < h/2 ? h : yyyy
        
        Log.d(
            "Popup:",
            yb,
            h,
            yyyy
        )
        
        btnUpdate.frame.origin.y =
            yb - btnUpdate.height() - h * 0.025
        
        btnUpdate.onClick = { [weak self] view in
            self?.onClickBtnUpdate(
                view
            )
        }
        
        view.addSubview(
            btnUpdate
        )
        
    }
    
    private func onClickBtnClose(
        _ sender: UIView
    ) {
        markAsRead()
        sender.isUserInteractionEnabled = false
        popBaseAnim()
    }
    
    private func onClickBtnUpdate(
        _ sender: UIView
    ) {
        UIApplication.openAppStorePage()
    }
    
    private func markAsRead() {
        UserDefaults.main().setValue(
            msgID,
            forKey: Keys.ID_NEWS
        )
    }
    
}
