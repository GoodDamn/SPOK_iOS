//
//  SettingsViewController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsViewController
    : SignInAppleController {
    
    private let TAG = "SettingsViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mSignListener = self
        
        view.backgroundColor = UIColor
            .background()
        
        let w = view.frame.width
        let h = view.frame.height
        
        let hbtnDelete = h * 0.1
        
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.07
            )
        targetClose(
            btnClose
        )
        
        let stackView = UIStackView(
            frame: CGRect(
                x: 0,
                y: h*0.4,
                width: w,
                height: h
            )
        )
        
        let btnDelete = UIButton(
            frame: CGRect(
                x: 0,
                y: h-hbtnDelete,
                width: w,
                height: hbtnDelete
            )
        )
        
        btnDelete.setTitleColor(
            .systemRed,
            for: .normal
        )
        
        btnDelete.setTitle(
            "Удалить аккаунт",
            for: .normal
        )
        
        btnDelete.addTarget(
            self,
            action: #selector(
                onClickBtnDelete(_:)
            ),
            for: .touchUpInside
        )
        
        view.addSubview(btnClose)
        view.addSubview(btnDelete)
    }
    
    @objc func onClickBtnDelete(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        signIn()
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
                print(
                    "SettingsViewController: REVOKE: ERROR",
                    error?.localizedDescription
                )
            }
            
            authData.user
                .delete { error in
                    print(
                        "SettingsViewController: DELETE_USER:",
                        error?.localizedDescription
                    )
                }
            
            
        }
        
        do {
            try auth.signOut()
        } catch {
            print(
                "SettingsViewController:",
                "SIGN_OUT_ERROR:",
                error.localizedDescription
            )
        }
        
    }
    
    func onErrorSign(
        _ msg: String
    ) {
        
    }
    
}
