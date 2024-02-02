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
    ) -> String {
        return self.string(
            forKey: key
        ) ?? "null"
    }
    
}
