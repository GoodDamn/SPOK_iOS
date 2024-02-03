//
//  IntroSleepViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class SplashViewController
    : StackViewController {
    
    var msgBottom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            named: "background"
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        let sizeTitle = w * 0.086
        let sizeSubtitle = w * 0.04
        
        let extraBold = UIFont(
            name: "OpenSans-ExtraBold",
            size: sizeTitle
        )
        
        let lTitle = UILabel(
            frame: CGRect(
                x: w*0.1,
                y: h*0.05,
                width: w,
                height: sizeTitle * 6
            )
        )
        
        let lSubtitle = UILabel(
            frame: CGRect(
                x: 0,
                y: h * 0.786,
                width: w,
                height: sizeSubtitle * 3
            )
        )
        
        let wimage = 0.683 * w
        let himage = 0.802 * wimage
        
        let imageView = UIImageView(
            frame: CGRect(
                x: (w - wimage) * 0.5,
                y: (h - himage) * 0.5,
                width: wimage,
                height: himage
            )
        )
        
        imageView.image = UIImage(
            named: "meditate"
        )
        
        lTitle.text = "Добро\nпожаловать в\nSPOK.Сон"
        lTitle.font = extraBold
        lTitle.textColor = .white
        lTitle.numberOfLines = 0
        
        lSubtitle.text = msgBottom
        lSubtitle.font = extraBold?
            .withSize(sizeSubtitle)
        lSubtitle.textColor = .white
        lSubtitle.textAlignment = .center
        lSubtitle.numberOfLines = 0
        
        
        view.addSubview(lTitle)
        view.addSubview(imageView)
        view.addSubview(lSubtitle)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
 
}
