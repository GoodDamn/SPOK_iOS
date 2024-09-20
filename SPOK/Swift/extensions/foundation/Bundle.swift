//
//  Bundle.swift
//  SPOK
//
//  Created by GoodDamn on 19/09/2024.
//

import Foundation

extension Bundle {
    
    func buildVersion() -> Int? {
        guard let vers = infoDictionary?[
            "CFBundleVersion"
        ] as? String else {
            return nil
        }
        
        return Int(vers)
    }
    
}
