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
            PreviewCell.self,
            forCellWithReuseIdentifier: PreviewCell.ID
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
        collectionView.frame = CGRect(
            x: 0,
            y: size.height * 0.1132,
            width: size.width,
            height: size.height * 0.7812
        )
    }
    
}
