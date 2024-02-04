//
//  AuthAppleController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import FirebaseAuth

class AuthAppleController
    : SignInAppleController {
    
    private let TAG = "AuthAppleController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mSignListener = self
        
    }
    
    internal func onAuthSuccess(){}
    internal func onAuthError(){}
    
    private func processSignIn(
        _ auth: AuthDataResult
    ) {
        
        UserDefaults
            .standard
            .setValue(
                auth.user.uid,
                forKey: Keys.USER_REF
            )
        
        onAuthSuccess()
    }
    
}

extension AuthAppleController
    : SignInListener {
    
    func onSuccessSign(
        token: String,
        nonce: String,
        authCode: String
    ) {
        let credentials = OAuthProvider
            .credential(
                withProviderID: "apple.com",
                idToken: token,
                rawNonce: nonce
            )
        
        Auth.auth().signIn(
            with: credentials
        ) { [weak self] authResult, error in
            
            guard let auth = authResult,
                  error == nil else {
                print(
                    self?.TAG,
                    "ERROR:",
                    error
                )
                return
            }
            
            self?.processSignIn(
                auth
            )
            
        }
    }
    
    func onErrorSign(
        _ msg: String
    ) {
        onAuthError()
    }
    
}
