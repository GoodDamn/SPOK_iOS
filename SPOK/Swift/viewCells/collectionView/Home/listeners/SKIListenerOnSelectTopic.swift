//
//  SKIListenerOnSelectTopic.swift
//  SPOK
//
//  Created by GoodDamn on 11/10/2024.
//

import Foundation

protocol SKIListenerOnSelectTopic
: AnyObject {
    
    func onSelectTopic(
        preview: SKModelTopicPreview?,
        collection: SKModelCollection?,
        id: Int
    )
    
}
