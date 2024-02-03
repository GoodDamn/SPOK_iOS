//
//  SplashViewController.swift
//  SPOK
//
//  Created by GoodDamn on 13/01/2024.
//

import Foundation
import UIKit

class SplashViewController
    : StackViewController {
    
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
        
        let splashLine = UIImageView(
            frame: CGRect(
                x: 0,
                y: h * 0.703,
                width: w * 1.023,
                height: w * 0.4
            )
        )
        
        splashLine.frame
            .center(
                targetWidth: w
            )
        
        splashLine.image = UIImage(
            named: "splashline"
        )
        
        view.addSubview(lTitle)
        view.addSubview(imageView)
        view.addSubview(splashLine)
    }
    
    
}
