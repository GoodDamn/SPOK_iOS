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
            .textButton(
                text: "Начать приключение"
            )
        
        LayoutUtils.textButton(
            for: btnStart,
            height: view.frame.height,
            textSize: 0.05
        )
        
        btnStart.frame.origin.y = h - btnStart.frame.height - h * 0.02 - Utils.insets().bottom
                
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
        
        page.layout(
            title: "Засыпайки",
            subtitle: "Всего пару минут,\nчтобы настроиться на сон.", [
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
        
        page2.layout(
            title: "Истории на ночь",
            subtitle: "Расслабляйся, читая\nневероятные рассказы", [
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
    
}

private final class Page
    : StackViewController {
    
    public var mOnLoadView: ((UIView)->Void)? = nil
    
    private var mCarouselView: CarouselView!
    
    override func viewDidAppear(
        _ animated: Bool
    ) {
        mCarouselView.start()
    }
    
    override func viewDidDisappear(
        _ animated: Bool
    ) {
        Log.d(Page.self, "viewDidDisappear")
        mCarouselView.stop()
    }
    
}

extension Page {
    public func layout(
        title: String,
        subtitle: String,
        _ carousels: [CarouselView.Carousel]
    ) {
        
        let h = view.height()
        let w = view.width()
        
        let space = h * 0.02
        
        let x = w * 0.05
        
        let hcv = MainViewController.mCardSizeB
            .height * 2 + space
        
        mCarouselView = CarouselView(
            carousels: carousels,
            space: space,
            frame: CGRect(
                x: -x,
                y: (h - hcv) * 0.5 + hcv * 0.042,
                width: w + x,
                height: hcv
            )
        )
        
        mCarouselView.transform = CGAffineTransform(
            rotationAngle: -5.35 / 180 * .pi
        )
        
        view.addSubview(
            mCarouselView
        )
        
        let header = ViewUtils.createHeader(
            frame: view.frame,
            title: title,
            subtitle: subtitle
        )
        
        header.frame.origin.y = (mCarouselView.frame.y() - header.height()) * 0.5
        
        view.addSubview(
            header
        )
        
        view.clipsToBounds = true
        
        mOnLoadView?(view)
        
    }
}

extension IntroSleep3ViewController {
    
    @objc private func onTap(
        _ sender: UITapGestureRecognizer
    ) {
        sender.isEnabled = false
        mPageController.mIndex = 1
    }
    
    @objc private func onClickBtnStart(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        self.hide()
    }
    
}
