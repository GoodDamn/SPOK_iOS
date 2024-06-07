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
            onAuth(auth:)
        
        mAuthMethod?.completionError =
            onAuthError(s:)
        signIn()
    }
    
    final func reauthenticate() {
        mAuthMethod = methodReauth
        
        mAuthMethod?.completion =
            onReauth(auth:)
        
        mAuthMethod?.completionError =
            onAuthError(s:)
        
        signIn()
    }
    
    internal func onAuthSuccess() {}
    internal func onReauthSucess() {}
    
    internal func onAuthError(
        s: String
    ) {}
}

extension AuthAppleController {
    
    private func onReauth(
        auth: AuthDataResult
    ) {
        onReauthSucess()
    }
    
    private func onAuth(
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
                
        mAuthMethod?.auth(
            auth: Auth.auth(),
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
