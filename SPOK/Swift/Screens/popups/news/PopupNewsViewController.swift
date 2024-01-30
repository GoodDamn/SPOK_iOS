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
        
        let lTitle = UILabela(
            frame: CGRect(
                x: mLeft,
                y: mInsets.top,
                width: wcontent,
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
                width: wcontent,
                height: h - lTitle.frame.bottom()
            )
        )
        
        lDesc.isScrollEnabled = true
        lDesc.text = msgDescription
        lDesc.font = semiBold
        lDesc.textColor = .white
        lDesc.backgroundColor = .clear
        
        
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
        
        view.addSubview(lTitle)
        view.addSubview(lDesc)
        view.addSubview(btnClose)
    }
}
