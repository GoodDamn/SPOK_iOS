//
//  ProfileNewViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class ProfileNewViewController
    : SignInAppleController {
    
    private let TAG = "ProfileNewViewController"
    
    private let mPayment = Payment(
        price: 169.00,
        currency: .rub,
        description: "SPOK Подписка на 1 месяц"
    )
    
    private var mPaymentProcess: PaymentProcess!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MainContentViewController", "viewDidLoad:", mInsets)
        
        modalPresentationStyle = .fullScreen
        
        let w = view.frame.width
        let h = view.frame.height - mInsets.bottom - 50 // 50 - height nav bar (MainContentViewController)
        
        let extraBold = UIFont(
            name: "OpenSans-ExtraBold",
            size: 15
        )
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: 15
        )
        
        let semiBold = UIFont(
            name: "OpenSans-SemiBold",
            size: 15
        )
        
        let marginTop = h * 0.04
        let marginLeft = w * 0.05
        
        let mTopOffset = mInsets.top
        
        let lTitle = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: mTopOffset == 0 ? marginTop : mTopOffset,
                width: w-marginLeft,
                height: w * 0.06
            )
        )
        
        let lTitleHead = UILabel(
            frame: CGRect(
                x: 0,
                y: lTitle
                    .frame.bottom() + h * 0.05,
                width: w,
                height: 0.05 * w
            )
        )
        
        let marginLeftSub = w * 0.108
        
        let lSubtitleHead = UILabela(
            frame: CGRect(
                x: marginLeftSub,
                y: lTitleHead.frame.bottom() + h*0.02,
                width: w-marginLeftSub*2,
                height: 0.032 * w
            )
        )
        
        lTitle.text = "Профиль"
        lTitle.textColor = .white
        lTitle.font = extraBold?
            .withSize(lTitle.frame.height)
        
        lTitle.sizeToFit()
        
        lTitleHead.textAlignment = .center
        lTitleHead.text = "Теперь можно все"
        lTitleHead.textColor = .white
        lTitleHead.font = bold?
            .withSize(lTitleHead.frame.height)
        
        lSubtitleHead.text = "Открой полный доступ ко всему контенту в приложении. Засыпай быстрее и улучши качество своего сна вместе со SPOK"
        lSubtitleHead.lineHeight = 0.83
        lSubtitleHead.textAlignment = .center
        lSubtitleHead.textColor = .white
        lSubtitleHead.font = semiBold?
            .withSize(lSubtitleHead
                .frame.height
        )
        lSubtitleHead.numberOfLines = 0
        lSubtitleHead.attribute()
        
        lSubtitleHead.sizeToFit()
        lSubtitleHead.frame.center(
            targetWidth: w
        )
        
        let himage2 = w * 0.434
        
        let imageView2 = UIImageView(
            frame: CGRect(
                x: w * 0.297,
                y: lSubtitleHead
                    .frame
                    .bottom() + h*0.03,
                width: himage2,
                height: himage2
            )
        )
        
        imageView2.image = UIImage(
            named: "i"
        )
        
        let himage1 = w * 0.352
        let offset = w * 0.14
        let ximg13 = lSubtitleHead.frame.bottom() + h * 0.06
        
        let imageView1 = UIImageView(
            frame: CGRect(
                x: w-(himage1-offset),
                y: ximg13,
                width: himage1,
                height: himage1
            )
        )
        
        imageView1.image = UIImage(
            named: "o"
        )
        
        let imageView3 = UIImageView(
            frame: CGRect(
                x: -offset,
                y: ximg13,
                width: himage1,
                height: himage1
            )
        )
        
        imageView3.image = UIImage(
            named: "j"
        )
        
        let lPrice = UILabel(
            frame: CGRect(
                x: 0,
                y: imageView2.frame.bottom() + h * 0.02,
                width: w,
                height: h * 0.028
            )
        )
        
        let a = NSMutableAttributedString(
            string: "369 RUB \(Int(mPayment.price)) RUB"
        )
        
        let strikeColor = UIColor
            .white
            .withAlphaComponent(
                0.7
            )
        
        a.addAttributes([
            NSAttributedString.Key
                .font: bold?
                    .withSize(lPrice
                        .frame.height * 0.6
            ),
            NSAttributedString.Key
                .foregroundColor: strikeColor,
            NSAttributedString.Key
                .strikethroughStyle: NSUnderlineStyle
                .single
                .rawValue,
            NSAttributedString.Key
                .strikethroughColor:
                    strikeColor
        ],range: NSRange(
            location: 0,
            length: 7)
        )
        
        lPrice.textColor = .white
        lPrice.textAlignment = .center
        lPrice.font = bold?
            .withSize(lPrice.frame.height)
        lPrice.attributedText = a
        
        lPrice.frame.offsetX(
            w * -0.065
        )
        
        let btnOpen = ViewUtils
            .button(
                text: "Открыть полный доступ"
            )
        
        LayoutUtils.button(
            for: btnOpen,
            view.frame,
            y: 0.85,
            width: 0.702,
            textSize: 0.28
        )
        
        btnOpen.frame.origin.y = lPrice.frame.bottom() + h * 0.03
        print("ProfileNewViewController:", "FRAMES:",view.bounds.size,UIScreen.main.bounds.size)
        let sharey = btnOpen.frame.bottom() + h * 0.03
        
        let lastHeight = h - sharey
        let hNeedShare = h * 0.25
        let hshare = lastHeight < hNeedShare ?
                lastHeight
              : hNeedShare
        let shareLeft = w * 0.051
        let wshare = w-shareLeft*2
        let shareView = UIView(
            frame: CGRect(
                x: shareLeft,
                y: sharey,
                width: wshare,
                height: hshare
            )
        )
        
        shareView.backgroundColor = UIColor(
            red: 17.0/255,
            green: 43.0/255,
            blue: 94.0/255,
            alpha: 1.0
        )
        shareView
            .layer
            .cornerRadius = hshare * 0.083
        
        
        let lShareLeft = wshare * 0.109
        let lShare = UILabela(
            frame: CGRect(
                x: lShareLeft,
                y: hshare * 0.15,
                width: wshare - lShareLeft*2,
                height: 0
            )
        )
        
        lShare.text = "Поделись своим впечатлением.\nСкажи, что тебе нравится и не нравится в приложении, а мы обещаем, что сделаем его лучше!"
        lShare.textColor = .white
        lShare.textAlignment = .center
        lShare.font = semiBold?
            .withSize(hshare * 0.068)
        lShare.lineHeight = 0.83
        lShare.numberOfLines = 0
        lShare.attribute()
        lShare.sizeToFit()
        
        let btnShare = ViewUtils
            .button(
                text: "Поделиться впечатлением"
            )
        
        LayoutUtils.button(
            for: btnShare,
            shareView.frame,
            y: 0.6,
            width: 0.782,
            height: 0.242,
            textSize: 0.28
        )
        
        btnShare.frame.origin.y =
            shareView.frame.height -
            btnShare.frame.height -
            shareView.frame.height * 0.155
        
        shareView.frame.center(
            targetHeight: lastHeight,
            offset: sharey
        )
        
        btnOpen.frame.center(
            targetHeight: shareView.frame.origin.y - lPrice.frame.bottom(),
            offset: lPrice.frame.bottom()
        )
        
        lPrice.frame.center(
            targetHeight: btnOpen.frame.origin.y - imageView2.frame.bottom(),
            offset: imageView2.frame.bottom()
        )
        
        view.addSubview(lTitle)
        view.addSubview(lTitleHead)
        view.addSubview(lSubtitleHead)
        
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        
        view.addSubview(lPrice)
        
        view.addSubview(shareView)
        shareView.addSubview(lShare)
        shareView.addSubview(btnShare)
        
        view.addSubview(btnOpen)
        
        btnOpen.addTarget(
            self,
            action: #selector(
                btnOpenFullAccess(_:)
            ),
            for: .touchUpInside
        )
        
        btnShare.addTarget(
            self,
            action: #selector(
                btnShareImpression(_:)
            ),
            for: .touchUpInside
        )
        
    }
    
    override func onSignSuccess() {
        startPayment()
    }
    
    @objc func btnOpenFullAccess(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        
        if AuthUtils.user() != nil {
            startPayment()
            return
        }
        
        // Authentication
        signIn()
    }
    
    @objc func btnShareImpression(
        _ sender: UIButton
    ) {
        let app = UIApplication.shared
        
        guard let url = URL(string: "https://forms.yandex.ru/cloud/659e823af47e735258a77960"
        ) else {
            print("ProfileNewViewController", "URL_ERROR:")
            return
        }
        
        app.open(url) { success in
            
            if success {
                print("SUCCESS")
            }
            
        }
    }
     
    private func startPayment() {
        mPaymentProcess = PaymentProcess(
            payment: mPayment
        )
        
        mPaymentProcess.start { [weak self]
            snap in
            if self == nil {
                return
            }
            DispatchQueue.ui {
                self?.pushConfirmPage(
                    snap
                )
            }
        }
    }
    
    
    private func pushConfirmPage(
        _ snap: PaymentSnapshot
    ) {
        let web = WebConfirmationViewController()
        web.mPaymentSnap = snap
        web.view.alpha = 0
        
        print(TAG, "pushConfirmPage")
        
        push(
            web,
            animDuration: 0.8
        ) {
            web.view.alpha = 1.0
        }
    }
    
    /*private func addStat(
        _ child: String
    ) {
        mDatabase
            .child("\(mCurrentStreak)_\(child)")
            .setValue(ServerValue
                .increment(1)
            )
    }*/
}

