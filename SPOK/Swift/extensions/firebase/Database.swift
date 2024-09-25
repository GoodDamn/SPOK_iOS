//
//  Database.swift
//  SPOK
//
//  Created by GoodDamn on 21/09/2024.
//

import Foundation
import FirebaseDatabase

extension Database {
    
    static func pirate() -> DatabaseReference {
        database().reference(
            withPath: "pir"
        )
    }
    
    static func user() -> DatabaseReference? {
        guard let id = SKUtilsAuth.user()?.uid else {
            return nil
        }
        
        return database().reference(
            withPath: "USERS/\(id)"
        )
    }
    
    
    static func sendContact(
        user: String,
        contact: String
    ) {
        database().reference(
            withPath: "contacts/\(user)"
        ).setValue(
            contact
        )
    }
}
