//
//  SettingsViewController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import UIKit
import FirebaseAuth
import UserNotifications.UNUserNotificationCenter

final class SettingsViewController
: AuthAppleController {
    
    private var mTableOptions: OptionsView!
    
    private var mOptionNotify: Option!
    private var mOptionRate: Option!
    private var mOptionSupport: Option!
    
    private var mOptionsNonUser: [Option]!
    private var mOptionsUser: [Option]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .background()
        
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
        
        btnClose.onClick = { [weak self] view in
            self?.onClickBtnClose(
                view: view
            )
        }
        
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
            select: { [weak self] view in
                self?.onClickBtnRate(
                    view: view
                )
            }
        )
        
        mOptionSupport = Option(
            image: UIImage(
                systemName: "message.fill"
            ),
            text: "Связь с разработчиками",
            textColor: .white,
            iconColor: .accent(),
            withView: nil,
            select: { [weak self] view in
                self?.onClickBtnSupport(
                    view: view
                )
            }
        )
        
        mOptionsNonUser = [
            mOptionNotify,
            mOptionRate,
            mOptionSupport,
            Option(
                image: UIImage(
                    named: "login"
                ),
                text: "Войти в аккаунт",
                textColor: .white,
                iconColor: .accent(),
                withView: nil,
                select: { [weak self] view in
                    self?.onClickBtnSignIn(
                        view: view
                    )
                }
            )
        ]
        
        mOptionsUser = [
            mOptionNotify,
            mOptionRate,
            mOptionSupport,
            Option(
                image: UIImage(
                    named: "login"
                ),
                text: "Выйти из аккаунта",
                textColor: .white,
                iconColor: .accent(),
                withView: nil,
                select: { [weak self] view in
                    self?.onClickBtnSignOut(
                        view: view
                    )
                }
            ),
            Option(
                image: UIImage(
                    systemName: "trash.fill"
                ),
                text: "Удалить аккаунт",
                textColor: .danger(),
                iconColor: .danger(),
                withView: nil,
                select: { [weak self] view in
                    self?.onClickBtnDelete(
                        view: view
                    )
                }
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
        
        UNUserNotificationCenter.settings {
            [weak self] perm in
            
            let status = perm
                .authorizationStatus
            
            let isOn = status == .authorized
            
            DispatchQueue.ui {
                mSwitcher.isOn = isOn
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
        
        mTableOptions = OptionsView(
            frame: CGRect(
                x: marginHorizontal,
                y: ytable,
                width: w - 2*marginHorizontal,
                height: h - ytable - mInsets.bottom
            ),
            rowHeight: hbtnDelete
        )
        
        mTableOptions.mOptions =
            SKUtilsAuth.user() == nil ?
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
        
        if SKViewControllerMain.mDoAppleCheck {
            return
        }
        
        view.addSubview(
            btnClose
        )
    }
    
    override func onReauthSuccess(
        _ auth: AuthDataResult,
        authCode: String
    ) {
        Log.d(
            SettingsViewController.self,
            "onReauthSucess:"
        )
        
        SKUtilsAuth.userDelete(
            auth: auth,
            authCode: authCode
        ) { [weak self] error in
            
            if error == nil {
                Toast.show(
                    text: "Аккаунт удален"
                )
                
                if self == nil {
                    return
                }
                
                self!.mTableOptions
                    .mOptions = self!.mOptionsNonUser
                
                return
            }
            
            Toast.show(
                text: "Ошибка удаления аккаунта: \(error!.localizedDescription)"
            )
        }
    }
    
    override func onAuthSuccess(
        _ auth: AuthDataResult,
        authCode: String
    ) {
        super.onAuthSuccess(
            auth,
            authCode: authCode
        )
        
        Toast.show(
            text: "Успешно"
        )
        
        mTableOptions.mOptions = mOptionsUser
    }
    
    override func onAuthError(
        error: String
    ) {
        Toast.show(
            text: "Ошибка: \(error)"
        )
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
        
        UIApplication.openSettings()
    }
    
    private func onClickBtnClose(
        view: UIView
    ) {
        view.isUserInteractionEnabled = false
        popBaseAnim()
    }
    
    private func onClickBtnRate(
        view: UIView
    ) {
        UIApplication.openAppStorePage()
    }
    
    private func onClickBtnSupport(
        view: UIView
    ) {
        UIApplication.openUrl(
            url: "https://t.me/aleksandrovprod"
        )
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
            SKUtilsAuth.userSignOut(
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
