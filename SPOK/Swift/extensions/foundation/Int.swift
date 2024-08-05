//
//  Int.swift
//  SPOK
//
//  Created by GoodDamn on 28/07/2024.
//

import Foundation

extension Int {
    
    static func currentTimeSec() -> Int {
        Int(
            Date().timeIntervalSince1970
        )
    }
    
    func nw() -> CGFloat {
        CGFloat(self) / 414.0
    }
    
    func nh() -> CGFloat {
        CGFloat(self) / 915.0
    }
}
