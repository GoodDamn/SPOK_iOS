//
//  AuthMethod.swift
//  SPOK
//
//  Created by GoodDamn on 06/06/2024.
//

import Foundation
import FirebaseAuth

class AuthMethod {
    internal var mAuthCode = ""
    
    weak var onAuthError: OnAuthErrorListener? = nil
    
    internal func auth(
        auth: Auth,
        authCode: String,
        credentials: OAuthCredential
    ) {}
    
}
