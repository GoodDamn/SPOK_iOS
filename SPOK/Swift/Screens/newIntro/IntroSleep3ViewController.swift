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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = view.frame.width
        let h = view.frame.height
        
        
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
            
            let btnStart = ViewUtils
                .button(
                    text: "Начать приключение",
                    y: 0.873,
                    self.view
                )
            
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
    
}

private class Page
    : UIViewController {
    
    private final let TAG = "Page:"
    
    public var mOnLoadView: ((UIView)->Void)? = nil
    
    private var mTitle = ""
    private var mSubtitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewUtils.createHeader(
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
