//
//  CollectionTopic.swift
//  SPOK
//
//  Created by GoodDamn on 16/01/2024.
//

import Foundation

public class CollectionTopic
    : Collection {
    var topicsIDs: [UInt16]
    var cardSize: CGSize
    var cardTextSize: CardTextSize
    var cardType: CardType
    
    init(
        topicsIDs: inout [UInt16],
        titleSize: CGFloat,
        cardSize: CGSize,
        title: String,
        height: CGFloat,
        idCell: String = UITableViewCellCollection
            .id,
        cardTextSize: CardTextSize,
        cardType: CardType
    ) {
        self.cardTextSize = cardTextSize
        self.topicsIDs = topicsIDs
        self.cardSize = cardSize
        self.cardType = cardType
        
        super.init(
            title: title,
            height: height,
            idCell: idCell,
            titleSize: titleSize
        )
    }
    
}
