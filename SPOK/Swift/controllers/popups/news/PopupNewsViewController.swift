//
//  PopupNews.swift
//  SPOK
//
//  Created by GoodDamn on 29/01/2024.
//

import Foundation
import UIKit
import StoreKit

class PopupNewsViewController
    : StackViewController {
    
    var msgType: Int = 0
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
        
        let mLeft = 0.08 * w
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.16
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
                .button(
                    text: "Хорошо"
                )
            LayoutUtils
                .button(
                    for: btnOk,
                    view.frame,
                    y: 0,
                    width: 0.7,
                    height: 0.05,
                    textSize: 0.35
                )
            
            btnOk.frame.origin.y =
                h - btnOk.frame.height - mBottom
            
            btnOk.addTarget(
                self,
                action: #selector(
                    onClickBtnClose(
                        _:
                    )
                ),
                for: .touchUpInside
            )
            
            view.addSubview(
                btnOk
            )
        }
        
        if !(msgType >= 1 && msgType <= 2) {
            return
        }
        
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
                height: 0.05,
                textSize: 0.35
            )
        
        let v = view.subviews[ // >= 3
            view.subviews.count - 1
        ]
        
        let yyyy = v.frame.origin.y
        
        let yb = yyyy < h/2 ? h : yyyy
        
        print(
            "Popup:",
            yb,
            h,
            yyyy
        )
        
        btnUpdate.frame.origin.y =
            yb - btnUpdate.frame.height - h * 0.025
        
        btnUpdate.addTarget(
            self,
            action: #selector(
                onClickBtnUpdate(
                    _:
                )
            ),
            for: .touchUpInside
        )
        
        view.addSubview(
            btnUpdate
        )
        
    }
    
    @objc override func onClickBtnClose(
        _ sender: UIButton
    ) {
        markAsRead()
        super.onClickBtnClose(sender)
    }
    
    @objc private func onClickBtnUpdate(
        _ sender: UIButton
    ) {
        
        let vc = SKStoreProductViewController();
        
        vc.loadProduct(
            withParameters: [
                SKStoreProductParameterITunesItemIdentifier: NSNumber(
                    value: 6443976042
                )
            ], completionBlock: nil)
        
        present(
            vc,
            animated: true
        )
    }
    
    private func markAsRead() {
        let def = UserDefaults.standard
        def.setValue(
            msgID,
            forKey: Keys.ID_NEWS
        )
    }
    
}
