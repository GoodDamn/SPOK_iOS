//
//  ByteUtils.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
class ByteUtils {
    
    private static let TAG = "ByteUtils"
    
    public static func short(
        _ data: [UInt8],
        _ off: Int
    ) -> Int {
        return Int(
            Int(data[off]) << 8 |
            Int(data[off+1])
        )
    }
    
    public static func int(
        _ data: [UInt8]
    ) -> Int {
        return int(data,0)
    }
    
    public static func int(
        _ data: [UInt8],
        _ off: Int
    ) -> Int {
        
        return Int(data[off])<<24 |
            Int(data[off+1])<<16 |
            Int(data[off+2])<<8 |
            Int(data[off+3])
        
    }
    
}
