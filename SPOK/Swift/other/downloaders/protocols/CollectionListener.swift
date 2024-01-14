//
//  CollectionListener.swift
//  SPOK
//
//  Created by GoodDamn on 13/01/2024.
//

import Foundation

public protocol CollectionListener {
    
    func onFirstCollection(
        c: [Collection]
    )
    
    func onAdd(
        i: Int
    )
    
    func onUpdate(
        i: Int
    )
    
    func onRemove(
        i: Int
    )
    
}
