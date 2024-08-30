//
//  UITableViewCellCollection.swift
//  SPOK
//
//  Created by Cell on 17.04.2022.
//

import UIKit

final class UITableViewCellCollection
: UITableViewCellTitle {
    
    static let id = "collections"
    
    private(set) var collectionView: UICollectionViewTopics!
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        selectionStyle = .none
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionViewTopics(
            frame: CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height
            ),
            collectionViewLayout: layout
        )
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        mTitle?.backgroundColor = .clear
           
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(
            UICollectionViewCellTopic.self,
            forCellWithReuseIdentifier: UICollectionViewCellTopic.ID
        )
        
        contentView.addSubview(
            collectionView
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    
    final func calculateBoundsCollection(
        with size: CGSize
    ) {
        let collViewHeight = size.height * 0.7811
        
        collectionView.frame = CGRect(
            x: 0,
            y: size.height - collViewHeight,
            width: size.width,
            height: collViewHeight
        )
        
        let left = mTitle?.frame.x() ?? 10
        
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: left
        )
    }
    
}
