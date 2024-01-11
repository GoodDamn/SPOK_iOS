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
            
        let page = Page()
        let page2 = Page()
        
        page.setHeader(
            title: "Засыпайки",
            subtitle: "Всего пару минут,\nчтобы настроиться на сон."
        )
        
        page2.setHeader(
            title: "Истории на ночь",
            subtitle: "Расслабляйся, читая\nневероятные рассказы"
        )
        
        page2.mOnLoadView = { v in
            
            let view = self.view!
            
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
                    self.onClickBtnStart(_:)
                ),
                for: .touchUpInside
            )
            
            v.addSubview(btnStart)
            
        }
        
        pageController.source = [
            page,
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
        
        view.addSubview(pageBar)
    }
    
    @objc func onClickBtnStart(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        self.hide()
    }
    
    public static func createHeader(
        in view: UIView,
        title: String,
        subtitle: String
    ) -> [UILabel] {
        
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
        
        return [lTitle, lSubtitle]
    }
    
}

private class Page
    : UIViewController {
    
    private final let TAG = "Page:"
    
    public var mOnLoadView: ((UIView)->Void)? = nil
    
    private var mTitle = ""
    private var mSubtitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IntroSleep3ViewController
            .createHeader(
                in:view,
                title: mTitle,
                subtitle: mSubtitle
            )
        
        let w = view.frame.width
        let h = view.frame.height
        
        view.clipsToBounds = true
        
        // 40 207 207
        
        let hcv = 0.496 * h
        
        let carouselView = CarouselView(
            carousels: [
                CarouselView.Carousel(
                    cellSize: CGSize(
                        width: 0.828,
                        height: 0.5
                    ),
                    type: CarouselView
                        .mTYPE_B,
                    from: 0.0,
                    delta: 0.1
                ),
                CarouselView.Carousel(
                    cellSize: CGSize(
                        width: 0.4,
                        height: 0.5
                    ),
                    type: CarouselView
                        .mTYPE_M,
                    from: 1.0,
                    delta: -0.1
                )
            ],
            frame: CGRect(
                x: 0,
                y: h * 0.256,
                width: w,
                height: hcv
            )
        )
        
        
        view.addSubview(carouselView)
        
        mOnLoadView?(view)
        
        carouselView.start()
    }
 
    public func setHeader(
        title: String,
        subtitle: String
    ) {
        mTitle = title
        mSubtitle = subtitle
    }
}
