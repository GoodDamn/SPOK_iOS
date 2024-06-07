//
//  AuthMethodSignIn.swift
//  SPOK
//
//  Created by GoodDamn on 06/06/2024.
//

import Foundation
import FirebaseAuth

final class AuthMethodSignIn
: AuthMethod {
    
    override func auth(
        auth: Auth,
        credentials: OAuthCredential
    ) {
        auth.signIn(
            with: credentials,
            completion: onSignIn(auth:error:)
        )
    }
    
}

extension AuthMethodSignIn {
    private func onSignIn(
        auth: AuthDataResult?,
        error: Error?
    ) {
        guard let data = auth,
              error == nil else {
            Log.d(
                AuthAppleController.self,
                "ERROR:",
                error
            )
            return
        }
    }
}
