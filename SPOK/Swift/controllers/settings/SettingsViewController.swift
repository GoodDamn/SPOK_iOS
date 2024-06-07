//
//  SettingsViewController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import UIKit
import FirebaseAuth

final class SettingsViewController
    : AuthAppleController {
    
    private var mTableOptions: OptionsTableView!
    
    private var mOptionNotify: Option!
    private var mOptionRate: Option!
    
    private var mOptionsNonUser: [Option]!
    private var mOptionsUser: [Option]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .background()
        
        let bold = UIFont
            .bold(withSize: 1)
        
        let w = view.frame.width
        let h = view.frame.height - mInsets.top
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.14,
                iconProp: 0.4
            )
        
        let beginPosY = mInsets.top < 1
            ? btnClose.frame.y()
            : mInsets.top
        
        btnClose.frame
            .origin.y = beginPosY
        
        btnClose.onClick = onClickBtnClose(_:)
        
        let hbtnDelete = h * 0.07
        let ytable = btnClose.frame.bottom()
        let marginHorizontal = w * 0.08
        
        let mSwitcher = UISwitch(
            frame: CGRect(
                x: 0,
                y: 0,
                width: w * 0.094,
                height: hbtnDelete * 0.38
            )
        )
    
        mOptionNotify = Option(
            image: UIImage(
                systemName: "bell.fill"
            ),
            text: "Уведомления",
            textColor: .white,
            iconColor: .accent(),
            withView: mSwitcher,
            select: nil
        )
        
        mOptionRate = Option(
            image: UIImage(
                systemName: "star.fill"
            ),
            text: "Оценить приложение",
            textColor: .white,
            iconColor: .accent(),
            withView: nil,
            select: onClickBtnRate
        )
        
        mOptionsNonUser = [
            mOptionNotify,
            mOptionRate,
            Option(
                image: UIImage(
                    named: "login"
                ),
                text: "Войти в аккаунт",
                textColor: .white,
                iconColor: .accent(),
                withView: nil,
                select: onClickBtnSignIn
            )
        ]
        
        mOptionsUser = [
            mOptionNotify,
            mOptionRate,
            Option(
                image: UIImage(
                    named: "login"
                ),
                text: "Выйти из аккаунта",
                textColor: .white,
                iconColor: .accent(),
                withView: nil,
                select: onClickBtnSignOut
            ),
            Option(
                image: UIImage(
                    systemName: "trash.fill"
                ),
                text: "Удалить аккаунт",
                textColor: .danger(),
                iconColor: .danger(),
                withView: nil,
                select: onClickBtnDelete
            )
        ]
        
        mSwitcher.addTarget(
            self,
            action: #selector(
                onSwitchNotify(_:)
            ),
            for: .valueChanged
        )
        
        mSwitcher.thumbTintColor = .background()
        mSwitcher.onTintColor = .white
        
        NotificationUtils.settings {
            perm in
            
            let status = perm
                .authorizationStatus
            
            DispatchQueue.ui {
                mSwitcher.isOn = status
                == .authorized
            }
        }
        
        let lSettings = UILabel(
            frame: CGRect(
                x: 0,
                y: btnClose.frame
                    .origin.y,
                width: w,
                height: btnClose.frame.height
            )
        )
        
        lSettings.backgroundColor = .clear
        lSettings.textColor = .white
        lSettings.font = .bold(
            withSize: lSettings.frame
                .height * 0.46
        )
        lSettings.textAlignment = .center
        lSettings.text = "Настройки"
        
        mTableOptions = OptionsTableView(
            frame: CGRect(
                x: marginHorizontal,
                y: ytable,
                width: w - 2*marginHorizontal,
                height: h - ytable - mInsets.bottom
            ),
            rowHeight: hbtnDelete
        )
        
        mTableOptions.mOptions =
            AuthUtils.user() == nil ?
                mOptionsNonUser
                : mOptionsUser
        
       mTableOptions.backgroundColor =
            .clear
        
        view.addSubview(
            lSettings
        )
        
        view.addSubview(
            mTableOptions
        )
        
        if MainViewController.mDoAppleCheck {
            return
        }
        
        view.addSubview(
            btnClose
        )
    }
    
    override func onReauthSuccess(
        auth: AuthDataResult,
        authCode: String
    ) {
        Log.d(
            SettingsViewController.self,
            "onReauthSucess:"
        )
        
        AuthUtils.userDelete(
            auth: auth,
            authCode: authCode
        ) { [weak self] error in
            
            if error == nil {
                Toast.init(
                    text: "Аккаунт удален",
                    duration: 1.0
                ).show()
                
                if self == nil {
                    return
                }
                
                self!.mTableOptions
                    .mOptions = self!.mOptionsNonUser
                
                return
            }
            
            Toast.init(
                text: "Ошибка удаления аккаунта: \(error!.localizedDescription)",
                duration: 1.0
            ).show()
        }
    }
    
    override func onAuthSuccess() {
        Toast.init(
            text: "Успешно",
            duration: 1.0
        ).show()
        
        mTableOptions.mOptions = mOptionsUser
    }
    
    override func onAuthError(
        s: String
    ) {
        Toast.init(
            text: "Ошибка: \(s)",
            duration: 1.0
        ).show()
    }
}

extension SettingsViewController {
    
    @objc private func onSwitchNotify(
        _ s: UISwitch
    ) {
        let app = UIApplication
            .shared
            
        if s.isOn {
            app
            .registerForRemoteNotifications()
        } else {
            app
            .unregisterForRemoteNotifications()
        }
        
        Utils.openSettings()
    }
    
    private func onClickBtnRate(
        view: UIView
    ) {
        ViewUtils.rateApp()
    }
    
    private func onClickBtnClose(
        _ sender: UIView
    ) {
        view.isUserInteractionEnabled = false
        popBaseAnim()
    }
    
    private func onClickBtnSignIn(
        view: UIView
    ) {
        authenticate()
    }
    
    private func onClickBtnDelete(
        view: UIView
    ) {
        ViewUtils.alertAction(
            title: "Удалить аккаунт?",
            message: "Подписка и сохраненные данные будут утеряны",
            controller: self
        ) { [weak self] _ in
            self?.reauthenticate()
        }
        
    }
    
    private func onClickBtnSignOut(
        view: UIView
    ) {
        ViewUtils.alertAction(
            title: "Выйти из аккаунта?",
            controller: self
        ) { [weak self] _ in
            AuthUtils.userSignOut(
                auth: Auth.auth()
            ) {
                Log.d(
                    SettingsViewController.self,
                    "USER_SIGNED_OUT"
                )
                
                if self == nil {
                    return
                }
                
                self!.mTableOptions.mOptions = self!
                    .mOptionsNonUser
                
            }
        }
        
    }
    
}
