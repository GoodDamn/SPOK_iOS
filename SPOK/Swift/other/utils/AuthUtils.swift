//
//  AuthUtils.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation
import FirebaseAuth

final class AuthUtils {
    
    public static func user(
    ) -> User? {
        return Auth
            .auth()
            .currentUser
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
                AuthUtils.self,
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
