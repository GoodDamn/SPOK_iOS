//
//  AuthMethodReauth.swift
//  SPOK
//
//  Created by GoodDamn on 06/06/2024.
//

import Foundation
import FirebaseAuth

final class AuthMethodReauth
    : AuthMethod {
    
    override func auth(
        auth: Auth,
        authCode: String,
        credentials: OAuthCredential
    ) {
        mAuthCode = authCode
        auth.currentUser?.reauthenticate(
            with: credentials,
            completion: onReauth(auth:error:)
        )
    }
    
}

extension AuthMethodReauth {
    
    private func onReauth(
        auth: AuthDataResult?,
        error: Error?
    ) {
        guard let data = auth,
              error == nil else {
            Log.d(
                AuthMethodReauth.self,
                "ERROR:",
                error
            )
            return
        }
        
        completion?(
            data,
            mAuthCode
        )
    }
    
}
