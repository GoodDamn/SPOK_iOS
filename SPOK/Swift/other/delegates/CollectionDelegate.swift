//
//  CollectionDelegate.swift
//  SPOK
//
//  Created by GoodDamn on 14/01/2024.
//

import Foundation
import UIKit

public class CollectionDelegate
    : NSObject {
    
    private final let TAG = "CollectionDelegate"
    
    private var mCollections: [Collection]!
        
    public func setCollections(
        _ m: [Collection]
    ) {
        mCollections = m
    }
    
}

extension CollectionDelegate
    : UICollectionViewDataSource {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        let a = mCollections[
            collectionView.tag
        ]
    
        let c = a
            .topicsIDs
            .count
        
        print(TAG, "numberOfItemsInSection", c)
        return c
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let collection = mCollections[
            collectionView.tag
        ]
        
        let id = collection
            .topicsIDs[
                indexPath.row
            ]
        
        print(TAG, "cellForItemAt", id, indexPath.row)
        
        let intID = Int(id);
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! PreviewCell;
        
        cell.contentView.alpha = 0
        
        cell.load(
            type: "B",
            id: intID
        )
        
        return cell;
    }
    
}

extension CollectionDelegate
    : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let col = mCollections[
            collectionView.tag
        ]
        
        print(TAG, "sizeForItemAt",
              col.cardSize)
        
        return col.cardSize
    }
    
}
