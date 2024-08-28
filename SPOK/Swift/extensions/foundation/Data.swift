//
//  Data.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
extension Data {
    
    mutating func scc() -> [SKModelCollection]? {
        if isEmpty {
            return nil
        }
        
        let n = Int(self[0])
        var collections = Array<SKModelCollection>()
        collections.reserveCapacity(n)
        
        var dd: FileSCS?
        var i = 1
        var lenCol: Int
        
        while (
            i < count
        ) {
            lenCol = ByteUtils.short(
                &self,
                offset: i
            )
            i += 2
            
            dd = Extension.scs(
                &self,
                offset: i
            )
            
            if let d = dd {
                if let t = d.topics {
                    collections.append(
                        SKModelCollection(
                            title: d.title,
                            topicIds: t
                        )
                    )
                }
            }
            
            i += lenCol
        }
        
        return collections
    }
    
}
