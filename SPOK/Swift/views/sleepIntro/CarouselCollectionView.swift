//
//  CarouselTableView.swift
//  SPOK
//
//  Created by GoodDamn on 10/01/2024.
//

import Foundation
import UIKit

final class CarouselCollectionView
    : UICollectionView {
    
    let cardCount: Int
    let cardOffset: Int
    
    private(set) var mCellSize: CGSize = .zero
    private(set) var mType: String =
        CarouselView.mTYPE_M
    
    private var mPosition = 0
    
    private var mPos: CGPoint = .zero
    
    init(
        type: String,
        cellSize: CGSize,
        frame: CGRect,
        cardCount: Int,
        cardOffset: Int
    ) {
        self.cardCount = cardCount
        self.cardOffset = cardOffset
        
        mCellSize = cellSize
        mType = type
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(
            frame: frame,
            collectionViewLayout: layout
        )
                
        register(
            ImageViewCell.self,
            forCellWithReuseIdentifier: ImageViewCell.id
        )
        
        backgroundColor = .clear
        
        isUserInteractionEnabled = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        isUserInteractionEnabled = false
    }
    
    
    required init?(
        coder: NSCoder
    ) {
        cardCount = 1
        cardOffset = 1
        super.init(
            coder: coder
        )
    }
    
}

final class ImageViewCell
    : UICollectionViewCell {
    
    public static let id = "iv"
    
    public final var mImageView: UIImageView!
    
    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        mImageView = UIImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height
            )
        )
        
        backgroundColor = .gray
        layer.cornerRadius = frame.height * 0.12
        
        contentView.addSubview(
            mImageView
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
