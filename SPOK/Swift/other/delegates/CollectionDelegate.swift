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
    
    private weak var mCollection: CollectionTopic!
    
    init(
        collection: CollectionTopic
    ) {
        mCollection = collection
    }
 
    public func registerCells(
        for colview: UICollectionView
    ) {
        colview.register(
            PreviewCell.self,
            forCellWithReuseIdentifier: PreviewCell.ID
        )
    }
    
}

extension CollectionDelegate
    : UICollectionViewDataSource {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        let c = mCollection
            .topicsIDs
            .count
        
        print(TAG, "numberOfItemsInSection", c)
        return c
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let id = mCollection
            .topicsIDs[
                indexPath.row
            ]
        
        print(TAG, "cellForItemAt", id, indexPath.row)
        
        let intID = Int(id);
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PreviewCell.ID,
            for: indexPath
        ) as! PreviewCell;
        
        cell.contentView.alpha = 0
        
        cell.mCardTextSize = mCollection.cardTextSize
        
        cell.load(
            type: mCollection.cardType,
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
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return collectionView.contentInset.left
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        print(TAG, "sizeForItemAt",
              mCollection.cardSize)
        
        return mCollection.cardSize
    }
    
}
