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
    
    weak var onSelectTopic: SKIListenerOnSelectTopic? = nil
    var collection: SKModelCollection? = nil
    var topicSize: CGSize = .zero
    var cardTextSize: CardTextSize = CardTextSize(
        title: 18.0,
        desc: 11.0
    )
    
    var insetsSection: UIEdgeInsets = .zero
    
}
