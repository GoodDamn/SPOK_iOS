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
    : SignInAppleController {
    
    private let TAG = "SettingsViewController"
    
    private var mTableOptions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mSignListener = self
        
        view.backgroundColor = UIColor
            .background()
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: 1
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        let hbtnDelete = h * 0.1
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.14
            )
        
        targetClose(
            btnClose
        )
        
        let ytable = h * 0.4
        
        mTableOptions = UITableView(
            frame: CGRect(
                x: 0,
                y: ytable,
                width: w,
                height: h - ytable - mInsets.bottom
            ),
            style: .plain
        )
        
        mTableOptions.backgroundColor =
            .clear
        
        /*btnDelete.setTitleColor(
            .systemRed,
            for: .normal
        )
        
        btnSignOut.setTitle(
            "Выйти из аккаунта",
            for: .normal
        )
        
        btnDelete.setTitle(
            "Удалить аккаунт",
            for: .normal
        )
        
        btnDelete.titleLabel?
            .font = bold?.withSize(
                hbtnDelete * 0.27
            )*/
        
        view.addSubview(btnClose)
    }
    
    @objc func onClickBtnDelete(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        signIn()
    }
    
    @objc func onClickBtnSignOut(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        do {
            try Auth.auth()
                .signOut()
        } catch {
            Log.d(
                TAG,
                "SIGN_OUT_FAIL:",
                error
            )
        }
        exit(0)
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
