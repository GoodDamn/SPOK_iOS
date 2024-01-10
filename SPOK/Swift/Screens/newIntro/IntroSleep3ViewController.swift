//
//  IntroSleep3ViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class IntroSleep3ViewController
    : DelegateViewController {
    
    private static var mExtraBold: UIFont? = nil
    private static var mSemiBold: UIFont? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = view.frame.width
        let h = view.frame.height
        
        let sizeTitle = w * 0.086
        let sizeSubtitle = w * 0.054
        
        IntroSleep3ViewController
            .mExtraBold = UIFont(
                name: "OpenSans-ExtraBold",
                size: sizeTitle
            )
        
        IntroSleep3ViewController
            .mSemiBold = UIFont(
                name: "OpenSans-SemiBold",
                size: sizeSubtitle
            )
        
        let pageController = SimplePageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        addChild(pageController)
        view.addSubview(pageController.view)
            
        pageController.source = [
            Page1(),
            Page2()
        ]
        
        pageController.setViewControllers(
            [pageController.source[0]],
            direction: .forward,
            animated: true
        )
        
    }
    
    private static func createHeader(
        in view: UIView,
        title: String,
        subtitle: String
    ) {
        
        let f = view.frame
        
        let extraBold = IntroSleep3ViewController
            .mExtraBold
        
        let semiBold = IntroSleep3ViewController
            .mSemiBold
        
        let w = f.width
        let h = f.height
        
        let marginLeft = w * 0.094
        
        let ww = w - marginLeft
        
        let lTitle = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: h*0.05,
                width: ww,
                height: extraBold?.pointSize ?? 36
            )
        )
    
        let fr = lTitle.frame
        let or = fr.origin
        
        let lSubtitle = UILabel(
            frame: CGRect(
                x: or.x,
                y: fr.height + or.y + w * 0.05,
                width: ww,
                height: (semiBold?.pointSize ?? 35) * 3
            )
        )
        
        lTitle.text = title
        lTitle.textColor = .white
        lTitle.font = extraBold
        lTitle.numberOfLines = 0
        
        lSubtitle.text = subtitle
        lSubtitle.textColor = .white
        lSubtitle.font = semiBold
        lSubtitle.numberOfLines = 0
        
        view.addSubview(lTitle)
        view.addSubview(lSubtitle)
    }
    
    
    private class Page1: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            IntroSleep3ViewController.createHeader(
                    in:view,
                    title: "Засыпайки",
                    subtitle: "Всего пару минут,\nчтобы настроиться на сон."
                )
        }
        
    }
    
    private class Page2: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            IntroSleep3ViewController.createHeader(
                    in:view,
                    title: "Истории на ночь",
                    subtitle: "Расслабляйся, читая\nневероятные рассказы"
                )
        }
        
    }
}
