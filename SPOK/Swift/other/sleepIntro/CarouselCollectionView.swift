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
        
        backgroundColor = .clear
        
        isUserInteractionEnabled = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        isUserInteractionEnabled = false
    }
    
    public func invalidatePos() {
        mPos.x += 0.1
        setContentOffset(
            mPos,
            animated: false
        )
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
    }
    
}
