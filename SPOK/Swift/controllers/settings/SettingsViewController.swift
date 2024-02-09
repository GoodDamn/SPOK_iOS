//
//  SettingsViewController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import UIKit
import FirebaseAuth
import StoreKit

final class SettingsViewController
    : SignInAppleController {
    
    private let TAG = "SettingsViewController"
    
    private var mTableOptions: OptionsTableView!
    
    private var mSwitcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mSignListener = self
        
        view.backgroundColor = .background()
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: 1
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.14,
                iconProp: 0.4
            )
        
        btnClose.frame
            .origin.y += mInsets.top
        
        let hbtnDelete = h * 0.07
        let ytable = btnClose.frame.bottom()
        let marginHorizontal = w * 0.08
        
        mSwitcher = UISwitch(
            frame: CGRect(
                x: 0,
                y: 0,
                width: w * 0.094,
                height: hbtnDelete * 0.38
            )
        )
        
        mSwitcher.thumbTintColor = .background()
        mSwitcher.onTintColor = .white
        
        targetClose(
            btnClose
        )
        
        let options = [
            Option(
                image: UIImage(
                    systemName: "bell.fill"
                ),
                text: "Уведомления",
                textColor: .white,
                iconColor: .accent(),
                withView: mSwitcher,
                select: onSwitchNotify
            ),
            Option(
                image: UIImage(
                    systemName: "star.fill"
                ),
                text: "Оценить приложение",
                textColor: .white,
                iconColor: .accent(),
                withView: nil,
                select: onClickBtnRate
            ),
            Option(
                image: UIImage(
                    systemName: "door.left.hand.open"
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
        
        print("OptionTableCell:", hbtnDelete)
        
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
                .height * 0.38
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
            source: options,
            rowHeight: hbtnDelete,
            style: .plain
        )
                
        mTableOptions
            .showsHorizontalScrollIndicator = false
        
        mTableOptions
            .showsVerticalScrollIndicator = false
        
        mTableOptions.separatorStyle = .none
        
        mTableOptions.backgroundColor =
            .clear
        
        view.addSubview(
            lSettings
        )
        
        view.addSubview(
            mTableOptions
        )
        
        view.addSubview(
            btnClose
        )
    }
    
    
    private func onSwitchNotify() {
        
        if mSwitcher.isEnabled {
            UIApplication
                .shared
                .registerForRemoteNotifications()
            return
        }
        
    }
    
    private func onClickBtnRate() {
        
        let store = SKStoreProductViewController()
        
        store.loadProduct(
            withParameters: [
                SKStoreProductParameterITunesItemIdentifier: NSNumber(
                    value: 6443976042
                )
            ]
        )
        
        Utils.main()
            .present(
                store,
                animated: true
            )
        
    }
    
    private func onClickBtnDelete() {
        ViewUtils.alertAction(
            title: "Удалить аккаунт?",
            message: "Подписка и сохраненные данные будут утеряны",
            controller: self
        ) { [weak self] _ in
            self?.signIn()
        }
        
    }
    
    private func onClickBtnSignOut() {
        ViewUtils.alertAction(
            title: "Выйти из аккаунта?",
            controller: self
        ) { [weak self] _ in
            
            do {
                try Auth.auth()
                    .signOut()
            } catch {
                Log.d(
                    self?.TAG,
                    "SIGN_OUT_FAIL:",
                    error
                )
            }
            exit(0)
        }
        
    }
    
}

extension SettingsViewController
    : SignInListener {
    
    func onSuccessSign(
        token: String,
        nonce: String,
        authCode: String
    ) {
        
        let auth = Auth.auth()
        
        let credentials = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: token,
            rawNonce: nonce
        )
        
        auth.currentUser?.reauthenticate(
            with: credentials
        ) { authData, error in
            
            guard let authData = authData,
                error == nil else {
                print(
                    "SettingsViewController: REAUTH:",
                    error
                )
                return
            }
            
            auth.revokeToken(
                withAuthorizationCode: authCode
            ) { error in
                Log.d(
                    "SettingsViewController: REVOKE: ERROR",
                    error?.localizedDescription
                )
            }
            
            DatabaseUtils
                .user()
                .removeValue()
            
            do {
                try auth.signOut()
            } catch {
                print(
                    "SettingsViewController:",
                    "SIGN_OUT_ERROR:",
                    error.localizedDescription
                )
            }
            
            authData.user
                .delete { error in
                    print(
                        "SettingsViewController: DELETE_USER:",
                        error?.localizedDescription
                    )
                    exit(0)
                }
        }
        
    }
    
    func onErrorSign(
        _ msg: String
    ) {
        
    }
    
}
