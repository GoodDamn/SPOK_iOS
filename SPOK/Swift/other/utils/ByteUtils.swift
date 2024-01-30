//
//  ByteUtils.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
class ByteUtils {
    
    private static let TAG = "ByteUtils"
    
    static func short(
        _ inp: inout Data,
        offset: Int = 0
    ) -> Int {
        let offset = offset + Int(inp.startIndex)
        return Int(inp[offset]) << 8 |
            Int(inp[offset+1])
        
    }
    
    static func int(
        _ inp: inout Data,
        offset: Int = 0
    ) -> Int {
        let offset = offset + Int(inp.startIndex)
        return Int(inp[offset]) << 24   |
            Int(inp[offset+1]) << 16 |
            Int(inp[offset+2]) << 8  |
            Int(inp[offset+3])
        
    }
    
}
