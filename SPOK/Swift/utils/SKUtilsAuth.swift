//
//  AuthUtils.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class SKUtilsAuth {
    
    static func user() -> User? {
        Auth.auth().currentUser
    }
    
    static func userSignOut(
        auth: Auth,
        completion: (()->Void)? = nil
    ) {
        do {
            try auth.signOut()
            UserDefaults
                .main()
                .removeObject(
                    forKey: .keyUserId()
                )
            completion?()
        } catch {
            Log.d(
                SKUtilsAuth.self,
                "userSignOut_ERROR:",
                error
            )
        }
    }
    
    static func userDelete(
        auth: AuthDataResult,
        authCode: String,
        completion: ((Error?)->Void)? = nil
    ) {
        let authh = Auth.auth()
        
        authh.revokeToken(
            withAuthorizationCode: authCode
        )
        
        Database.user()?
            .removeValue()
        
        userSignOut(
            auth: authh
        )
        
        auth.user.delete(
            completion: completion
        )
    }
    
}
