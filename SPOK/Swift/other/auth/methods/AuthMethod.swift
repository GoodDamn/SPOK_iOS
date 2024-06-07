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
    
    var completion: ((
        AuthDataResult,
        String
    ) -> Void)? = nil
    
    var completionError: ((
        String
    ) -> Void)? = nil
    
    internal func auth(
        auth: Auth,
        authCode: String,
        credentials: OAuthCredential
    ) {}
    
}
