//
//  CarouselTableView.swift
//  SPOK
//
//  Created by GoodDamn on 10/01/2024.
//

import Foundation
import UIKit

class CarouselCollectionView
    : UICollectionView {
    
    private final let TAG = "CarouselCollectionView"
    
    public var mCellSize: CGSize = .zero
    public var mType: String =
        CarouselView.mTYPE_M
    
    private var mPosition = 0
    
    private var mPos: CGPoint = .zero
    
    init(
        type: String,
        cellSize: CGSize,
        frame: CGRect
    ) {
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
        super.init(
            coder: coder
        )
    }
    
}

class ImageViewCell
    : UICollectionViewCell {
    
    public static let id = "iv"
    
    public var mImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mImageView = UIImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height
            )
        )
        
        print("CarouselCollectionView:",frame)
        
        contentView.addSubview(
            mImageView
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //contentView.frame = mImageView.frame
        print("CarouselCollectionView: layoutSubviews()")
        
    }
    
}
