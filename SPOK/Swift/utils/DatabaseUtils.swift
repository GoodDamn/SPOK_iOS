//
//  DatabaseUtils.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import FirebaseDatabase

final class DatabaseUtils {
    
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
}
