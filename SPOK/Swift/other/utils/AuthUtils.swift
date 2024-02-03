//
//  AuthUtils.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation
import FirebaseAuth

class AuthUtils {
    
    public static func user(
    ) -> User? {
        return Auth
            .auth()
            .currentUser
    }
    
}
