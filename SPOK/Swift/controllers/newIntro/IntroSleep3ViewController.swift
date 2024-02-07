//
//  IntroSleep3ViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

final class IntroSleep3ViewController
    : DelegateViewController {
    
    private var mPageController: SimplePageViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = view.frame.width
        let h = view.frame.height
        
        mPageController = SimplePageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        addChild(mPageController)
        view.addSubview(mPageController.view)
            
        let btnStart = ViewUtils
            .button(
                text: "Начать приключение"
            )
        
        LayoutUtils.button(
            for: btnStart,
            view.frame,
            y: 0,
            width: 0.702,
            textSize: 0.28
        )
        
        btnStart.frame.origin.y = h - btnStart.frame.height - h * 0.02 - Utils.insets().bottom
        
        btnStart.addTarget(
            self,
            action: #selector(
                self.onClickBtnStart(_:)
            ),
            for: .touchUpInside
        )
        
        let bsf = btnStart.frame
        
        let hPageBar = h * 0.03
        
        let pageBar = PageBar(
            frame: CGRect(
                x: w * 0.374,
                y: bsf.origin.y - hPageBar - h*0.019,
                width: w * 0.241,
                height: hPageBar
            )
        )
        
        let m = MainViewController
            .mCardSizeM!
        let b = MainViewController
            .mCardSizeB!
        
        let page = Page()
        let page2 = Page()
        
        page2.mOnLoadView = { v in
            v.addSubview(btnStart)
        }
        
        page.setHeader(
            title: "Засыпайки",
            subtitle: "Всего пару минут,\nчтобы настроиться на сон."
        )
        
        page.setCarousels([
            CarouselView.Carousel(
                cellSize: b,
                type: CarouselView
                    .mTYPE_B,
                from: 0.0,
                delta: 0.1
            ),
            CarouselView.Carousel(
                cellSize: m,
                type: CarouselView
                    .mTYPE_M,
                from: 1.0,
                delta: -0.1
            )
        ])
        
        page2.setHeader(
            title: "Истории на ночь",
            subtitle: "Расслабляйся, читая\nневероятные рассказы"
        )
        
        page2.setCarousels([
            CarouselView.Carousel(
                cellSize: b,
                type: CarouselView
                    .mTYPE_B,
                from: 0.0,
                delta: 0.1
            ),
            CarouselView.Carousel(
                cellSize: b,
                type: CarouselView
                    .mTYPE_M,
                from: 1.0,
                delta: -0.1
            )
        ])
        
        mPageController.source = [
            page,
            page2
        ]
        
        mPageController.withGesture = false
        
        mPageController.setViewControllers(
            [mPageController.source[0]],
            direction: .forward,
            animated: true
        )
        
        pageBar.maxPages = 2
        pageBar.mColorBack = .white
            .withAlphaComponent(0.2)
        
        pageBar.mColorCurrent = .white
        
        pageBar.mInterval = 0.12
        
        pageBar.mCurrentPage = 0
        
        mPageController.onNewPage = { i in
            pageBar.mCurrentPage = i
        }
        
        view.addSubview(pageBar)
        
        let g = UITapGestureRecognizer(
            target: self,
            action: #selector(
                onTap(_:)
            )
        )
        
        g.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(
            g
        )
    }
    
    @objc func onTap(
        _ sender: UITapGestureRecognizer
    ) {
        sender.isEnabled = false
        mPageController.mIndex = 1
    }
    
    @objc func onClickBtnStart(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        self.hide()
    }
    
}

private class Page
    : StackViewController {
    
    private final let TAG = "Page:"
    
    public var mOnLoadView: ((UIView)->Void)? = nil
    
    private var mTitle = ""
    private var mSubtitle = ""
    
    private var mCarouselView: CarouselView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewUtils.createHeader(
            in: view,
            title: mTitle,
            subtitle: mSubtitle
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        view.clipsToBounds = true
        
    }
 
    override func viewDidAppear(
        _ animated: Bool
    ) {
        mCarouselView?.start()
    }
    
    override func viewDidDisappear(
        _ animated: Bool
    ) {
        print(TAG, "viewDidDisappear")
        mCarouselView?.stop()
    }
    
    public func setCarousels(
        _ carousels: [CarouselView.Carousel]
    ) {
        // 40 207 207
        
        let h = view.frame.height
        let w = view.frame.width
        
        let hcv = 0.496 * h
        
        mCarouselView = CarouselView(
            carousels: carousels,
            frame: CGRect(
                x: 0,
                y: h * 0.256 + mInsets.top * 0.3,
                width: w,
                height: hcv
            )
        )
        
        view.addSubview(
            mCarouselView!
        )
        
        mOnLoadView?(view)
        
    }
    
    public func setHeader(
        title: String,
        subtitle: String
    ) {
        mTitle = title
        mSubtitle = subtitle
    }
}
