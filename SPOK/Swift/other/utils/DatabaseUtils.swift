//
//  DatabaseUtils.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import FirebaseDatabase

class DatabaseUtils {
    
    public static let TAG = "DatabaseUtils"
    
    public static func time(
        completion: @escaping (Int) -> Void
    ) {
        let ref = Database
            .database()
            .reference(
                withPath: "opt/time"
            )
        
        ref.observeSingleEvent(
            of: .value
        ) { snap in
            completion(
                snap.value as! Int
            )
        }
    }
    
    public static func user(
    ) -> DatabaseReference? {
        guard let id = UserDefaults
            .standard
            .string(
                Keys.USER_REF
            ) else {
            return nil
        }
        
        print(
            DatabaseUtils.TAG,
            "USER_ID:",
            id
        )
        
        return Database
            .database()
            .reference(
                withPath: "USERS/\(id)"
            )
    }
    
    public static func deleteUserValue(
        key: String
    ) {
        user()?
            .child(key)
            .removeValue()
    }
    
    public static func setUserValue(
        _ value: Any,
        to: String
    ) {
        user()?
            .child(to)
            .setValue(value)
    }
    
    public static func userValue(
        from: String,
        completion: @escaping (Any?) -> Void
    ) {
        user()?
            .child(from)
            .observeSingleEvent(
                of: .value
        ) { snap in
            completion(
                snap.value
            )
        }
        
    }
    
    public static func apiKey(
        _ key: String,
        completion: @escaping ((String) -> Void)
    ) {
        
        let ref = Database
            .database()
            .reference(
                withPath: "API_KEYS/\(key)"
            )
        
        ref.observeSingleEvent(
            of: .value
        ) { snap in
            
            guard let apikey = snap.value as? String else {
                Log.d(
                    DatabaseUtils.TAG,
                    "apiKey: INVALID"
                )
                return
            }
            
            completion(
                apikey
            )
        }
        
    }
    
}
