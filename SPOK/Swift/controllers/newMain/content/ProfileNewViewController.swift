//
//  ProfileNewViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit
import StoreKit

final class ProfileNewViewController
    : AuthAppleController {
    
    private let TAG = "ProfileNewViewController"
    
    private let mPayment = Payment(
        price: 169.00,
        currency: .rub,
        description: "SPOK Подписка на 1 месяц"
    )
    
    private var messageController: MessageViewController? = nil
    
    private var mPaymentProcess: PaymentProcess!
    private var mBtnOpenAccess: UIButton!
    private var mLabelPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MainContentViewController", "viewDidLoad:", mInsets)
        
        modalPresentationStyle = .fullScreen
        
        view.clipsToBounds = true
        
        let w = view.frame.width
        let h = view.frame.height - mInsets.bottom - 50 // 50 - height nav bar (MainContentViewController)
        
        let extraBold = UIFont.extrabold(
            withSize: 15
        )
        
        let bold = UIFont.bold(
            withSize: 15
        )
        
        let semiBold = UIFont.semibold(
            withSize: 15
        )
        
        let marginTop = h * 0.04
        let marginLeft = w * 0.05
        
        let mTopOffset = mInsets.top
        
        let btnSettings = ViewUtils
            .buttonClose(
                "gearshape.fill",
                in: view,
                sizeSquare: 0.13,
                iconProp: 0.4
            )
        
        btnSettings.tintColor = .white
        btnSettings.click(
            for: self,
            action: #selector(
                onClickBtnSettings(_:)
            )
        )
        
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
        
        mLabelPrice = UILabel(
            frame: CGRect(
                x: 0,
                y: imageView2.frame.bottom() + h * 0.02,
                width: w,
                height: h * 0.028
            )
        )
        
        let a = NSMutableAttributedString(
            string: "369 RUB \(Int(mPayment.price)) RUB / мес."
        )
        
        let strikeColor = UIColor
            .white
            .withAlphaComponent(
                0.7
            )
        
        a.addAttributes([
            NSAttributedString.Key
                .font: bold?
                    .withSize(mLabelPrice
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
        
        mLabelPrice.textColor = .white
        mLabelPrice.textAlignment = .center
        mLabelPrice.font = bold?
            .withSize(mLabelPrice.frame.height)
        mLabelPrice.attributedText = a
        
        mLabelPrice.frame.offsetX(
            w * -0.065
        )
        
        mBtnOpenAccess = ViewUtils
            .button(
                text: ""
            )
        
        mBtnOpenAccess
            .titleLabel?
            .numberOfLines = 0
        
        mBtnOpenAccess
            .titleLabel?
            .textAlignment = .center
        
        layoutPriceBtn()
        
        mBtnOpenAccess.frame.origin.y = mLabelPrice.frame.bottom() + h * 0.03
        
        let sharey = mBtnOpenAccess
            .frame.bottom() + h * 0.03
        
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
        
        mBtnOpenAccess.frame.center(
            targetHeight: shareView.frame.origin.y - mLabelPrice.frame.bottom(),
            offset: mLabelPrice.frame.bottom()
        )
        
        mLabelPrice.frame.center(
            targetHeight: mBtnOpenAccess.frame.origin.y - imageView2.frame.bottom(),
            offset: imageView2.frame.bottom()
        )
        
        view.addSubview(btnSettings)
        view.addSubview(lTitle)
        view.addSubview(lTitleHead)
        view.addSubview(lSubtitleHead)
        
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        
        view.addSubview(mLabelPrice)
        
        view.addSubview(shareView)
        shareView.addSubview(lShare)
        shareView.addSubview(btnShare)
        
        view.addSubview(mBtnOpenAccess)
        
        mBtnOpenAccess.click(
            for: self,
            action: #selector(
                btnOpenFullAccess(_:)
            )
        )
        
        btnShare.click(
            for: self,
            action: #selector(
                btnShareImpression(_:)
            )
        )
        
    }
    
    override func onUpdateState() {
        layoutPriceBtn()
    }
    
    override func onAuthSuccess() {
        messageController?
            .pop()
        messageController = nil
        startPayment()
    }
    
    override func onAuthError() {
        if messageController == nil {
            return
        }
        
        messageController!
            .pop(
                duration: 0.3
            ) { [weak self] in
                self?.messageController!.view
                    .alpha = 0.0
            }
        messageController = nil
    }
    
    @objc func btnOpenFullAccess(
        _ sender: UIButton
    ) {
        if MainViewController
            .mIsPremiumUser {
            Toast.init(
                text: "Подписка пока действует",
                duration: 1.5
            ).show()
            return
        }
        
        sender.isEnabled = false
        
        if AuthUtils.user() != nil {
            startPayment()
            return
        }
        
        messageController = MessageViewController()
        
        messageController!.msg = "Перед тем, как\nпродолжить создадим твой аккаунт..."
        
        messageController!.mAction = { [weak self] in
            sender.isEnabled = true
            self?.signIn()
        }
        
        let v = messageController!
            .view!
        
        v.alpha = 0.0
        push(
            messageController!,
            animDuration: 0.4
        ) {
            v.alpha = 1.0
        }
        
    }
    
    @objc func onClickBtnSettings(
        _ sender: UIButton
    ) {
        let settings = SettingsViewController()
        pushBaseAnim(
            settings,
            animDuration: 0.3
        )
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
    
}


extension ProfileNewViewController {
    
    private func startPayment() {
        if MainViewController.mIsShitPayment {
            startShitPayment()
            return
        }
        
        startNativePayment()
    }
    
    private func startShitPayment() {
        if #available(iOS 15.4, *) {
            Task {
                do {
                    try await ExternalPurchaseLink
                        .open()
                } catch {
                    print(
                        "startShitPayment: ERROR:",
                        error
                    )
                }
            }
            return
        }
        
        guard let url = URL(
            string: "https://spokapp.com/pay"
        ) else {
            return
        }
        
        UIApplication
            .shared
            .open(
                url
            )
        
    }
    
    private func startNativePayment() {
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
    
    private func layoutPriceBtn() {
        
        var textSize = 0.28
        var height = 0.051
        
        var title = "Открыть полный доступ"
        
        if MainViewController
            .mIsShitPayment {
            
            title = "Оплата подписки на сайте:\nhttps://spokapp.com/pay"
            
            height = 0.1
            textSize = 0.22
        }
        
        mLabelPrice.isHidden = MainViewController
            .mIsShitPayment
        
        mBtnOpenAccess.setTitle(
            title,
            for: .normal
        )
        
        LayoutUtils.button(
            for: mBtnOpenAccess,
            view.frame,
            y: 0.85,
            width: 0.702,
            height: height,
            textSize: textSize
        )
    }
    
    private func pushConfirmPage(
        _ snap: PaymentSnapshot
    ) {
        
        let web = WebConfirmationViewController()
        web.mPaymentSnap = snap
        web.view.alpha = 0
        
        web.mPaymentListener = self
        
        Log.d(
            TAG,
            "pushConfirmPage"
        )
        
        push(
            web,
            animDuration: 0.8
        ) {
            web.view.alpha = 1.0
        }
        
        mBtnOpenAccess.isEnabled = true
    }
    
}

extension ProfileNewViewController
    : PaymentConfirmationListener {
    
    func onPaid() {
        MainViewController
            .mIsPremiumUser = true
        callUpdatePremium()
    }
    
    func onExitPayment() {}
}
