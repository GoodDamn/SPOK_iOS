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
    
    private var mBtnStart: UITextButton!
    
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
        
        mBtnStart = ViewUtils
            .textButton(
                text: "Начать приключение"
            )
        
        LayoutUtils.textButton(
            for: mBtnStart,
            size: view.frame.size,
            textSize: 0.014,
            paddingHorizontal: 0.3,
            paddingVertical: 0.03
        )
        
        mBtnStart.centerH(
            in: view
        )
        
        mBtnStart.corner(
            normHeight: 0.2
        )
        
        let insets = Utils.insets()
        
        let btnStartY = h -
            mBtnStart.frame.height - h * 0.02 -
            insets.bottom
        
        let hPageBar = h * 0.03
        
        let pageButtonOffsetBet =  h*0.019
        
        let pageBarY = btnStartY - hPageBar -
            pageButtonOffsetBet
        
        let pageButtonHeight = btnStartY + mBtnStart.height() - pageBarY
        
        let m = MainViewController
            .mCardSizeM!
        let b = MainViewController
            .mCardSizeB!
        
        let page = Page()
        let page2 = Page()
        
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
        
        let pageButtonY = page2.carouselY()
            + pageButtonHeight * 0.5
        
        let pageBar = PageBar(
            frame: CGRect(
                x: 0,
                y: pageButtonY,
                width: w * 0.241,
                height: hPageBar
            )
        )
        
        mBtnStart.frame.origin.y = pageBar
            .bottomy() +
            pageButtonOffsetBet
        
        pageBar.centerH(
            in: view
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
        
        mBtnStart.scale(
            x: 0.0,
            y: 0.0
        )
        mBtnStart.isUserInteractionEnabled = false
        
        view.addSubview(mBtnStart)
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
    
    private final var mCarouselView: CarouselView!
    
    override final func viewDidAppear(
        _ animated: Bool
    ) {
        mCarouselView.start()
    }
    
    override final func viewDidDisappear(
        _ animated: Bool
    ) {
        Log.d(Page.self, "viewDidDisappear")
        mCarouselView.stop()
    }
    
    final func carouselY() -> CGFloat {
        mCarouselView.bottomy()
    }
    
    final func layout(
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
        
        header.frame.origin.y = mInsets.top + (mCarouselView.frame.y() - mInsets.top - header.height()) * 0.5
        
        view.addSubview(
            header
        )
        
        view.clipsToBounds = true
    }
    
}

extension IntroSleep3ViewController {
    
    @objc private func onTap(
        _ sender: UITapGestureRecognizer
    ) {
        sender.isEnabled = false
        mPageController.mIndex = 1
        mBtnStart.animate(
            animations: { [weak self] in
                self?.mBtnStart.scale()
            }
        ) { [weak self] _ in
            self?.mBtnStart
                .isUserInteractionEnabled = true
        }
        
    }
    
    @objc private func onClickBtnStart(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        self.hide()
    }
    
}
