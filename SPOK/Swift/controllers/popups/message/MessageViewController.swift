//
//  MessageViewController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import UIKit

class MessageViewController
    : StackViewController {
    
    var msg = ""
    var mAction: (()->Void)? = nil
    
    override func loadView() {
        let blurView = UIVisualEffectView(
            frame: .zero
        )
        
        blurView.effect = UIBlurEffect(
            style: .systemChromeMaterialDark
        )
        
        view = blurView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let w = view.frame.width
        let h = view.frame.height
        
        let marginTitle = w * 0.18
        let lTitle = UILabel(
            frame: CGRect(
                x: marginTitle,
                y: h * 0.4,
                width: 0,
                height: 0
            )
        )
        
        lTitle.textAlignment = .center
        lTitle.numberOfLines = 0
        lTitle.font = UIFont(
            name: "OpenSans-ExtraBold",
            size: w * 0.053
        )
        lTitle.textColor = .white
        lTitle.text = msg
        lTitle.sizeToFit()
        
        let f = lTitle.frame
        
        lTitle.frame.origin.x = (w-f.size.width) * 0.5
        
        view.addSubview(lTitle)
        
    }
    
    override func onTransitionEnd() {
        mAction?()
    }
    
}
