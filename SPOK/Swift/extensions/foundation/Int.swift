//
//  Int.swift
//  SPOK
//
//  Created by GoodDamn on 28/07/2024.
//

import Foundation

extension Int {
    
    func nw() -> CGFloat {
        CGFloat(self) / 414.0
    }
    
    func nh() -> CGFloat {
        CGFloat(self) / 915.0
    }
}
