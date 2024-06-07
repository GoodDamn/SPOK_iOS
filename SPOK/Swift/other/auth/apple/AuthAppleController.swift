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
    
    private var mAuthMethod: AuthMethod? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mSignListener = self
    }
    
    func signInSimply() {
        signIn()
    }
    
    func reauthenticate() {
        signIn()
    }
    
    internal func onSimplySignIn(){}
    
    internal func onReauth(
        auth: AuthDataResult
    ){}
    internal func onReauthError(){}
    
    internal func onAuthSuccess(){}
    internal func onAuthError(){}
    
}

extension AuthAppleController {
    
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
        if mAuthMethod == nil {
            Log.d(
                AuthAppleController.self,
                "onSuccessSign: ERROR:",
                "AUTH_METHOD=nil"
            )
            return
        }
        
        let credentials = OAuthProvider
            .credential(
                withProviderID: "apple.com",
                idToken: token,
                rawNonce: nonce
            )
        
        let auth = Auth.auth()
        
        mAuthMethod?.auth(
            auth: auth,
            credentials: credentials
        )
        
    }
    
    func onErrorSign(
        _ msg: String
    ) {
        onAuthError()
    }
    
}
