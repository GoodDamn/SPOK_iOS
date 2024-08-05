//
//  AuthAppleController.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import FirebaseAuth

class AuthAppleController
: SignInAppleController,
OnAuthErrorListener,
OnAuthSuccessListener,
OnReauthSuccessListener {
    
    private let methodReauth = AuthMethodReauth()
    private let methodSignIn = AuthMethodSignIn()
    
    private var mAuthMethod: AuthMethod? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mSignListener = self
    }
    
    final func authenticate() {
        methodSignIn.onAuthSuccess = self
        
        mAuthMethod = methodSignIn
        mAuthMethod?.onAuthError = self

        signIn()
    }
    
    final func reauthenticate() {
        methodReauth.onReauthSuccess = self
        
        mAuthMethod = methodReauth
        mAuthMethod?.onAuthError = self
        
        signIn()
    }
    
    internal func onAuthSuccess(
        _ auth: AuthDataResult,
        authCode: String
    ) {
        UserDefaults
            .standard
            .setValue(
                auth.user.uid,
                forKey: Keys.USER_REF
            )
    }
    
    internal func onAuthError(
        error: String
    ) {
        
    }
    
    internal func onReauthSuccess(
        _ auth: AuthDataResult,
        authCode: String
    ) {}
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
        onAuthError(
            error: msg
        )
    }
    
}
