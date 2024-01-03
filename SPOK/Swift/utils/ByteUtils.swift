//
//  ByteUtils.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
class ByteUtils {
    
    
    public static func short(
        _ data: [Int8],
        _ off: Int
    ) -> Int16 {
        return Int16(
            data[off] << 8 |
            data[off+1]
        )
    }
    
    public static func int(
        _ data: [Int8],
        _ off: Int
    ) -> Int32 {
        return Int32(
            data[off]<<24 |
            data[off+1]<<16 |
            data[off+2]<<8 |
            data[off+3]
        )
    }
    
}
