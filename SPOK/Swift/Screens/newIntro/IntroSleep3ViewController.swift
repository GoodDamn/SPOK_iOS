//
//  IntroSleep3ViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class IntroSleep3ViewController
    : UIViewController {
    
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
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal
        )
        
        pageController.source = [
            Page1(),
            Page2()
        ]
        
        pageController.setViewControllers(
            [Page1()],
            direction: .forward,
            animated: true)
        
        
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
        
        let lTitle = UILabel(
            frame: CGRect(
                x: w*0.01,
                y: h*0.05,
                width: w,
                height: extraBold?.pointSize ?? 36
            )
        )
        
        let orig = lTitle.frame.origin
        
        let lSubtitle = UILabel(
            frame: CGRect(
                x: orig.x,
                y: orig.y + lTitle.frame.height,
                width: w,
                height: semiBold?.pointSize ?? 70
            )
        )
        
        lTitle.text = title
        lTitle.textColor = .white
        lTitle.font = extraBold
        
        lSubtitle.text = subtitle
        lSubtitle.textColor = .white
        lSubtitle.font = semiBold
        
        view.addSubview(lTitle)
        view.addSubview(lSubtitle)
    }
    
    
    private class Page1: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            IntroSleep3ViewController.createHeader(
                    in:view,
                    title: "Засыпайки",
                    subtitle: "Всего пару минут, чтобы настроиться на сон."
                )
        }
        
    }
    
    private class Page2: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            IntroSleep3ViewController.createHeader(
                    in:view,
                    title: "Истории на ночь",
                    subtitle: "Расслабляйся, читая невероятные рассказы"
                )
        }
        
    }
}
