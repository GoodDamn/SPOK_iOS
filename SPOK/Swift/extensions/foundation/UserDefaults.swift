//
//  UserDefaults.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation.NSUserDefaults

extension UserDefaults {
    
    static func string(
        data: String,
        key: String
    ) {
        standard.setValue(
            data,
            forKey: key
        )
    }
    
    static func string(
        _ key: String
    ) -> String? {
        return standard.string(
            forKey: key
        )
    }
    
    static func timeForAppleCheck() -> TimeInterval {
        return standard.double(
            forKey: Keys.USER_DEF_APPLE_PREV_TIME
        )
    }
    
    static func doAppleCheck() -> Bool {
        return standard.bool(
            forKey: Keys.USER_DEF_APPLE_CHECK
        )
    }
    
    static func userID() -> String? {
        return standard.string(
            forKey: Keys.USER_REF
        )
    }
    
    static func contacts() -> String? {
        return standard.string(
            forKey: "contacts"
        )
    }
    
    static func contacts(
        data: String
    ) {
        string(
            data: data,
            key: "contacts"
        )
    }
    
}
