//
//  TimeInterval.swift
//  SPOK
//
//  Created by GoodDamn on 22/09/2024.
//

import Foundation

extension TimeInterval {
    
    static func days7Sec() -> TimeInterval {
        604_800
    }
    
    
    func toTimeString() -> String {
        let sec = Int(self)
        let mins2 = sec / 60
        let mins1 = mins2 / 10
        
        let sec2 = sec % 60
        let sec1 = sec2 / 10
        
        return "\(mins1)\(mins2 % 10):\(sec1)\(sec2 % 10)"
    }
    
    
}
