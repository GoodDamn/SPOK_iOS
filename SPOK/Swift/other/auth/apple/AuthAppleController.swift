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
    
    private let methodReauth = AuthMethodReauth()
    private let methodSignIn = AuthMethodSignIn()
    
    private var mAuthMethod: AuthMethod? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mSignListener = self
    }
    
    final func authenticate() {
        mAuthMethod = methodSignIn
        mAuthMethod?.completion =
            onAuth(_:authCode:)
        
        mAuthMethod?.completionError =
            onAuthError(s:)
        signIn()
    }
    
    final func reauthenticate() {
        mAuthMethod = methodReauth
        
        mAuthMethod?.completion =
            onReauthSuccess(auth:authCode:)
        
        mAuthMethod?.completionError =
            onAuthError(s:)
        
        signIn()
    }
    
    internal func onAuthSuccess() {}
    internal func onReauthSuccess(
        auth: AuthDataResult,
        authCode: String
    ) {}
    
    internal func onAuthError(
        s: String
    ) {}
}

extension AuthAppleController {
    
    private func onAuth(
        _ auth: AuthDataResult,
        authCode: String
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
                
        mAuthMethod?.auth(
            auth: Auth.auth(),
            authCode: authCode,
            credentials: OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: token,
                rawNonce: nonce
            )
        )
        
    }
    
    func onErrorSign(
        _ msg: String
    ) {
        mAuthMethod?.completionError?(
            msg
        )
    }
    
}
