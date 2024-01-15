//
//  Iterator.swift
//  SPOK
//
//  Created by GoodDamn on 14/01/2024.
//

import Foundation

public class Iterator<Element> {
    
    private var mFrom: Int
    private var marr: [Element]
    
    init(
        _ a: [Element]
    ) {
        mFrom = 0
        marr = a
    }
    
    public func index() -> Int {
        if mFrom == 0 {
            return 0
        }
        return mFrom - 1
    }
    
    public func next() -> Element? {
        if mFrom < marr.count {
            
            let e = marr[mFrom]
            mFrom += 1
            
            return e
        }
        
        return nil
    }
    
}
