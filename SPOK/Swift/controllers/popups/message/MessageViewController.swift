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
    var mBlurView: UIVisualEffectView!
    
    override func loadView() {
        mBlurView = UIVisualEffectView(
            frame: UIScreen.main.bounds
        )
        
        mBlurView.effect = UIBlurEffect(
            style: .systemChromeMaterialDark
        )
        print("loadView:")
        view = mBlurView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mBlurView.backgroundColor = .clear
        mBlurView.contentView
            .backgroundColor = .clear
        
        let w = view.frame.width
        let h = view.frame.height
        
        let marginTitle = w * 0.159
        let lTitle = UILabel(
            frame: CGRect(
                x: marginTitle,
                y: h * 0.4,
                width: w-marginTitle*2,
                height: 0
            )
        )
        
        lTitle.textAlignment = .center
        lTitle.numberOfLines = 0
        lTitle.font = UIFont(
            name: "OpenSans-ExtraBold",
            size: w * 0.051
        )
        lTitle.textColor = .white
        lTitle.text = msg
        lTitle.sizeToFit()
        
        let f = lTitle.frame
        
        lTitle.frame.origin.x = (w-f.size.width) * 0.5
        
        mBlurView.contentView
            .addSubview(lTitle)
        
    }
    
    override func onTransitionEnd() {
        mAction?()
    }
    
}
