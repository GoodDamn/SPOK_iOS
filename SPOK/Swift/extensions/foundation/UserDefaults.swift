//
//  UserDefaults.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation.NSUserDefaults

extension UserDefaults {
    
    func string(
        _ key: String
    ) -> String? {
        return self.string(
            forKey: key
        )
    }
    
    func timeForAppleCheck() -> TimeInterval {
        return double(
            forKey: Keys.USER_DEF_APPLE_PREV_TIME
        )
    }
    
    func doAppleCheck() -> Bool {
        return bool(
            forKey: Keys.USER_DEF_APPLE_CHECK
        )
    }
    
    func userID() -> String? {
        return string(
            forKey: Keys.USER_REF
        )
    }
    
}
