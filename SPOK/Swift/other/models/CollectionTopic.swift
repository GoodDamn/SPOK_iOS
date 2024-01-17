//
//  CollectionTopic.swift
//  SPOK
//
//  Created by GoodDamn on 16/01/2024.
//

import Foundation

public class CollectionTopic
    : Collection {
    let topicsIDs: [UInt16]
    let titleSize: CGFloat
    let cardSize: CGSize
    
    init(
        topicsIDs: [UInt16],
        titleSize: CGFloat,
        cardSize: CGSize,
        title: String,
        height: CGFloat
    ) {
        self.topicsIDs = topicsIDs
        self.titleSize = titleSize
        self.cardSize = cardSize
        
        super.init(
            title: title,
            height: height
        )
    }
    
}
