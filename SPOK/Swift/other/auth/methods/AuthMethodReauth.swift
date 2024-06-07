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
        credentials: OAuthCredential
    ) {
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
        
    }
    
}
