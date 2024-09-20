//
//  AuthUtils.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation
import FirebaseAuth

final class SKUtilsAuth {
    
    public static func user() -> User? {
        Auth.auth().currentUser
    }
    
    public static func userSignOut(
        auth: Auth,
        completion: (()->Void)? = nil
    ) {
        do {
            try auth.signOut()
            UserDefaults
                .standard
                .removeObject(
                    forKey: Keys
                        .USER_REF
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
    
    public static func userDelete(
        auth: AuthDataResult,
        authCode: String,
        completion: ((Error?)->Void)? = nil
    ) {
        let authh = Auth.auth()
        
        authh.revokeToken(
            withAuthorizationCode: authCode
        )
        
        DatabaseUtils
            .user()?
            .removeValue()
        
        userSignOut(
            auth: authh
        )
        
        auth.user.delete(
            completion: completion
        )
    }
    
}
