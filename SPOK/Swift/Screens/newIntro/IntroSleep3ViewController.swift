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
            
        let page2 = Page2()
        
        pageController.source = [
            Page1(),
            page2
        ]
        
        pageController.setViewControllers(
            [pageController.source[0]],
            direction: .forward,
            animated: true
        )
        
        let pageBar = PageBar(
            frame: CGRect(
                x: w * 0.374,
                y: h * 0.831,
                width: w * 0.241,
                height: h * 0.016
            )
        )
        
        pageBar.maxPages = 2
        pageBar.mColorBack = .white
            .withAlphaComponent(0.2)
        
        pageBar.mColorCurrent = .white
        
        pageBar.mInterval = 0.12
        
        pageBar.mCurrentPage = 0
        
        pageController.onNewPage = { i in
            pageBar.mCurrentPage = i
        }
        
        page2.onClickStart = { btn in
            btn.isEnabled = false
            self.hide()
        }
        
        view.addSubview(pageBar)
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
    
    class Page2: UIViewController {
        
        var onClickStart: ((UIButton)->Void)? = nil
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            IntroSleep3ViewController.createHeader(
                    in:view,
                    title: "Истории на ночь",
                    subtitle: "Расслабляйся, читая\nневероятные рассказы"
                )
            
            let w = view.frame.width
            let h = view.frame.height
            
            let wbtn = w * 0.702
            
            let btnStart = UIButton(
                frame: CGRect(
                    x: (w - wbtn) * 0.5,
                    y: h * 0.873,
                    width: wbtn,
                    height: h * 0.05
                )
            )
            
            let bold = UIFont(
                name: "OpenSans-Bold",
                size: 0.26 * btnStart.frame.height
            )
            
            btnStart.backgroundColor = UIColor(
                named: "btnBack"
            )
            
            btnStart
                .layer
                .cornerRadius = 0.17 * btnStart.frame.height
            
            btnStart.titleLabel?.font = bold
            btnStart.setTitleColor(
                .white,
                for: .normal
            )
            
            btnStart.setTitle(
                "Начать приключение",
                for: .normal)
            
            btnStart.addTarget(
                self,
                action: #selector(
                    onClickBtnStart(_:)
                ),
                for: .touchUpInside
            )
            
            view.addSubview(btnStart)
        }
        
        @objc func onClickBtnStart(
            _ sender: UIButton
        ) {
            onClickStart?(sender)
        }
        
    }
}
