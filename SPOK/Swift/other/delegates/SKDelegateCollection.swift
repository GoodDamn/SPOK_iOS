//
//  SKDelegateCollection.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation

protocol SKDelegateCollection
: AnyObject {
    func onGetCollections(
        collections: inout [SKModelCollection]
    )
}
