//
//  collectionsCellCollView.swift
//  SPOK
//
//  Created by Cell on 17.04.2022.
//

import UIKit;
public class CollectionTableViewCell
    : TitleTableViewCell {
    
    public static let id = "collections"
    
    public var collectionView: UICollectionView!
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        print("CollectionTableViewCell: init()",frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(
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
        print("CollectionTableViewCell: init(CODER)")
        super.init(coder:coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let a = mTitle?.frame.origin.x ?? 0
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: a,
            bottom: 0,
            right: a
        )
    }
    
}
