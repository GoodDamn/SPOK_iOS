//
//  DatabaseUtils.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import FirebaseDatabase

final class DatabaseUtils {
    
    public static func contact(
        user: String,
        contacts: String
    ) {
        Database.database()
            .reference(
                withPath: "contacts/\(user)"
            ).setValue(
                contacts
            )
    }
    
    public static func pirate(
        completion: @escaping (Bool) -> Void
    ) {
        let ref = Database
            .database()
            .reference(
                withPath: "pir"
            )
        
        ref.observeSingleEvent(
            of: .value
        ) { snap in
            completion(
                snap.exists()
            )
        }
    }
    
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
            .string(
                Keys.USER_REF
            ) else {
            return nil
        }
        
        Log.d(
            DatabaseUtils.self,
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
        to: String,
        completion: (() -> Void)? = nil
    ) {
        user()?
            .child(to)
            .setValue(
                value,
                withCompletionBlock: {
                    error, ref in
                    if error != nil {
                        Log.d(
                            DatabaseUtils.self,
                            "ERROR: setUserValue",
                            error
                        )
                        return
                    }
                    completion?()
                }
            )
    }
    
    public static func userValue(
        from: String,
        completion: @escaping (Any?) -> Void
    ) {
        let user = user()
        if user == nil {
            completion(
                nil
            )
            return
        }
        
        user?.child(from)
            .observeSingleEvent(
                of: .value,
                with: { snap in
                    completion(
                        snap.value
                    )
                }
            ) { error in
                completion(
                    nil
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
                    DatabaseUtils.self,
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
