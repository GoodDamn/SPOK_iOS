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
    
    var msgDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            named: "background"
        )
        
        let extraBold = UIFont(
            name: "OpenSans-ExtraBold",
            size: 1
        )
        
        let semiBold = UIFont(
            name: "OpenSans-SemiBold",
            size: 1
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
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
        lTitle.backgroundColor = .red
        lTitle.lineHeight = 0.83
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
        lDesc.backgroundColor = .gray
        
        view.addSubview(lTitle)
        view.addSubview(lDesc)
    }
    
}
