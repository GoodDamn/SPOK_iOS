//
//  IntroSleepViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

final class SplashViewController
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
        
        let lTitle = UILabela(
            frame: CGRect(
                x: w*0.1,
                y: h*0.05,
                width: w*0.9,
                height: 0
            )
        )
        
        let lSubtitle = UILabela(
            frame: CGRect(
                x: 0,
                y: h * 0.786,
                width: w,
                height: 0
            )
        )
        
        let wimage = 0.683 * w
        let himage = 0.872 * wimage
        
        let imageView = UIImageView(
            frame: CGRect(
                x: (w - wimage) * 0.5,
                y: (h - himage) * 0.51,
                width: wimage,
                height: himage
            )
        )
        
        imageView.image = UIImage(
            named: "meditate"
        )
        
        lTitle.text = "Добро\nпожаловать\nв SPOK.Сон"
        lTitle.font = extraBold
        lTitle.textColor = .white
        lTitle.textAlignment = .center
        lTitle.numberOfLines = 0
        lTitle.lineHeight = 0.83
        
        lSubtitle.text = msgBottom
        lSubtitle.font = extraBold?
            .withSize(sizeSubtitle)
        lSubtitle.textColor = .white
        lSubtitle.textAlignment = .center
        lSubtitle.numberOfLines = 0
        lSubtitle.lineHeight = 0.83
        
        lTitle.sizeToFit()
        lSubtitle.sizeToFit()
        
        lTitle.frame.origin.x = (w -
            lTitle.width()) * 0.5
        
        lTitle.frame.origin.y = (
            imageView.frame.y() - lTitle.height()) * 0.5
        
        lSubtitle.frame.origin.x = (w -
            lSubtitle.width()) * 0.5
        
        lSubtitle.frame.origin.y =
            imageView.bottomy() +
        (h - imageView.bottomy() - lSubtitle.height()) * 0.5
        
        
        view.addSubview(lTitle)
        view.addSubview(imageView)
        view.addSubview(lSubtitle)
    }
    
}
