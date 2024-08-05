//
//  ProfileNewViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit
import FirebaseAuth

final class ProfileNewViewController
    : AuthAppleController {
    
    private var messageController: MessageViewController? = nil
    
    private var mBtnOpenAccess: UITextButton!
    
    private static let mPayment = Payment(
        price: 169.00,
        currency: .rub,
        description: "Подписка SPOK на 1 месяц"
    )
    
    private var mPaymentProcess = PaymentProcess(
        payment: ProfileNewViewController
            .mPayment,
        email: ""
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .fullScreen
        
        view.clipsToBounds = true
        
        let w = view.width()
        let h = view.height() - mInsets.bottom - 50 // 50 - height nav bar (MainContentViewController)
        
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
        btnSettings.onClick =
            onClickBtnSettings(_:)
        
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
            .withSize(lTitle.height())
        
        lTitle.sizeToFit()
        
        lTitleHead.textAlignment = .center
        lTitleHead.text = "Теперь можно все"
        lTitleHead.textColor = .white
        lTitleHead.font = bold?
            .withSize(lTitleHead.height())
        
        lSubtitleHead.text = "Новые засыпайки и истории на ночь каждую неделю. Засыпай быстрее и улучши качество своего сна вместе со SPOK"
        lSubtitleHead.lineHeight = 0.83
        lSubtitleHead.textAlignment = .center
        lSubtitleHead.textColor = .white
        lSubtitleHead.font = semiBold?
            .withSize(lSubtitleHead
                .height()
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
                    .bottom() + h * 0.03,
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
        
        let lPrice = UILabela()
        let lPriceOld = UILabela()
        let price = ProfileNewViewController
            .mPayment
            .price
        
        lPrice.text = "\(Int(price)) RUB / месяц"
        lPrice.font = .bold(
            withSize: w * 0.0479
        )
        lPrice.textColor = .white
        lPrice.attribute()
        lPrice.sizeToFit()
        
        
        lPriceOld.text = "249 RUB"
        lPriceOld.font = .bold(
            withSize: lPrice.font.pointSize * 0.739
        )
        lPriceOld.textColor = .white
            .withAlphaComponent(
                0.7
            )
        lPriceOld.isStrikethroughed = true
        lPriceOld.attribute()
        lPriceOld.sizeToFit()
        
        mBtnOpenAccess = UITextButton(
            frame: CGRect(
                x: 0,
                y: 0,
                width: w*0.5,
                height: 30
            )
        )
        
        mBtnOpenAccess = ViewUtils.textButton(
            text: "Открыть полный доступ"
        )
        
        LayoutUtils.textButton(
            for: mBtnOpenAccess,
            size: view.frame.size,
            textSize: 0.017,
            paddingHorizontal: 0.18,
            paddingVertical: 0.03
        )
        
        mBtnOpenAccess.textColor = .white
        mBtnOpenAccess.font = bold
        
        mBtnOpenAccess.backgroundColor = .accent()
        mBtnOpenAccess.textAlignment = .center
        
        mBtnOpenAccess.centerH(
            in: view
        )

        mBtnOpenAccess.corner(
            normHeight: 0.2
        )
        
        mBtnOpenAccess.onClick =
            onClickBtnOpenFullAccess(_:)
        
        lPrice.centerH(
            in: view
        )
        
        lPrice.frame.origin.y = imageView2.frame
            .bottom() + h * 0.03
        
        lPriceOld
            .frame
            .origin = CGPoint(
                x: lPrice.frame.x() -
                    lPriceOld.frame.width * 1.15,
                y: lPrice.frame.y() + lPrice.font
                    .pointSize - lPriceOld.font
                    .pointSize
                
            )
        
        
        mBtnOpenAccess.frame.origin.y = lPrice.frame
            .bottom() + h * 0.03
        
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
        
        shareView.corner(
            normHeight: 0.083
        )
        
        
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
            .textButton(
                text: "Поделиться впечатлением"
            )
        
        LayoutUtils.textButton(
            for: btnShare,
            size: view.frame.size,
            textSize: 0.016,
            paddingHorizontal: 0.2,
            paddingVertical: 0.03
        )
        
        btnShare.onClick = onClickBtnShareImpression(_:)
        
        btnShare.frame.origin.y =
            shareView.height() -
            btnShare.height() -
            shareView.height() * 0.155
        
        btnShare.corner(
            normHeight: 0.2
        )
        
        btnShare.centerH(
            in: shareView
        )
        
        shareView.centerH(
            in: view
        )
        
        view.addSubview(btnSettings)
        view.addSubview(lTitle)
        view.addSubview(lTitleHead)
        view.addSubview(lSubtitleHead)
        
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        
        view.addSubview(shareView)
        shareView.addSubview(lShare)
        shareView.addSubview(btnShare)
        
        view.addSubview(
            lPrice
        )
        
        view.addSubview(
            lPriceOld
        )
        
        view.addSubview(
            mBtnOpenAccess
        )
        
    }
    
    override func onAuthSuccess(
        _ auth: AuthDataResult,
        authCode: String
    ) {
        super.onAuthSuccess(
            auth,
            authCode: authCode
        )
        
        messageController?
            .pop()
        messageController = nil
        startPayment()
    }
    
    override func onAuthError(
        error: String
    ) {
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
    
}


extension ProfileNewViewController {
    
    private func onClickBtnOpenFullAccess(
        _ sender: UIView
    ) {
        
        if !MainViewController
            .mCanPay {
            Toast.show(
                text: "Проверка подписки"
            )
            return
        }
        
        if MainViewController
            .mIsPremiumUser {
            Toast.show(
                text: "Подписка пока действует"
            )
            return
        }
        
        sender.isUserInteractionEnabled = false
        
        if AuthUtils.user() != nil {
            startPayment()
            sender.isUserInteractionEnabled = true
            return
        }
        
        messageController = MessageViewController()
        
        messageController!.msg = "Перед тем, как\nпродолжить создадим твой аккаунт..."
        
        messageController!.mAction = { [weak self] in
            sender.isUserInteractionEnabled = true
            self?.authenticate()
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
    
    private func onClickBtnShareImpression(
        _ sender: UIView
    ) {
        FragmentUtils.openUrl(
            urls: "https://forms.yandex.ru/cloud/659e823af47e735258a77960"
        )
    }
    
    private func onClickBtnSettings(
        _ sender: UIView
    ) {
        pushBaseAnim(
            SettingsViewController(),
            animDuration: 0.3
        )
    }
    
}

extension ProfileNewViewController {
    
    private func onGetEmail(
        email: String
    ) {
        mPaymentProcess = PaymentProcess(
            payment: ProfileNewViewController
                .mPayment,
            email: email
        )
        
        mPaymentProcess.start { [weak self]
            snap in
            
            DispatchQueue.ui {
                let c =
                WebConfirmationViewController()
                c.mPaymentListener = self
                c.mPaymentSnap = snap
                
                self?.pushBaseAnim(
                    c,
                    animDuration: 0.3
                )
            }
        }
    }
    
    private func startPayment() {
        let c = EmailConfirmationViewController()
        
        c.onConfirmEmail = onGetEmail(email:)
        
        present(
            c,
            animated: true
        )
    }
    
}

extension ProfileNewViewController
    : PaymentConfirmationListener {
    
    func onPaid() {
        DispatchQueue.ui { [weak self] in
            MainViewController.mIsPremiumUser =
                true
            self?.callUpdatePremium()
        }
    }
    
    func onExitPayment() {
        
    }
    
}
