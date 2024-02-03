//
//  CGRect.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation

extension CGRect {
    
    func bottom() -> CGFloat {
        return height + origin.y
    }

    mutating func center(
        targetHeight: CGFloat,
        offset: CGFloat = 0
    ) {
        origin.y = offset + (targetHeight - height) * 0.5
    }
    
    mutating func center(
        targetWidth: CGFloat
    ) {
        origin.x = (targetWidth - width) * 0.5
    }
    
    mutating func offsetX(
        _ offx: CGFloat
    ) {
        origin.x = origin.x + offx
    }
    
}
