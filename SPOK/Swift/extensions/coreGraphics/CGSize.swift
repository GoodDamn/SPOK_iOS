//
//  CGSize.swift
//  SPOK
//
//  Created by GoodDamn on 10/04/2024.
//

import Foundation

extension CGSize {
    
    func rnd() -> CGSize {
        CGSize(
            width: round(width),
            height: round(height)
        )
    }
    
}
