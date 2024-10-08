//
//  UICollectionViewTopics.swift
//  SPOK
//
//  Created by GoodDamn on 29/08/2024.
//

import Foundation
import UIKit

final class UICollectionViewTopics
: UICollectionView {
    
    var topics: [UInt16]? = nil
    var topicSize: CGSize = .zero
    var topicType: String? = nil
    var cardType: CardType = .M
    var cardTextSize: CardTextSize = CardTextSize(
        title: 18.0,
        desc: 11.0
    )
    
    var insetsSection: UIEdgeInsets = .zero
    
}
