//
//  UserDefaults.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation.NSUserDefaults

extension UserDefaults {
    
    static func main() -> UserDefaults {
        standard
    }
    
    static func stats() -> UserDefaults {
        UserDefaults(
            suiteName: "stats"
        ) ?? standard
    }
    
    static func statsKey(
        _ key: String
    ) -> Int {
        return stats().integer(
            forKey: key
        )
    }
    
    static func statsInc(
        _ key: String
    ) {
        let s = stats()
        let v = s.integer(
            forKey: key
        )
        
        s.setValue(
            v + 1,
            forKey: key
        )
    }
    
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
            forKey: .keyUserId()
        )
    }
    
    static func userID(
        _ id: String
    ) {
        standard.setValue(
            id,
            forKey: .keyUserId()
        )
    }
    
    static func isIntroCompleted() -> Bool {
        standard.bool(
            forKey: .keyIntro()
        )
    }
    
    static func completeIntro() {
        standard.setValue(
            true,
            forKey: .keyIntro()
        )
    }
    
    static func oldBuildNumber(
        _ i: Int
    ) {
        standard.setValue(
            i,
            forKey: Keys.OLD_BUILD_NUMBER
        )
    }
    
    static func oldBuildNumber() -> Int {
        standard.integer(
            forKey: Keys.OLD_BUILD_NUMBER
        )
    }
    
    static func anonId() {
        string(
            data: .currentTimeSeconds(),
            key: "anonId"
        )
    }
    
    static func anonId() -> String? {
        return string(
            "anonId"
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
