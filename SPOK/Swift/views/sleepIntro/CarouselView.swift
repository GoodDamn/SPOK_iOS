//
//  CarouselView.swift
//  SPOK
//
//  Created by GoodDamn on 11/01/2024.
//

import Foundation
import UIKit

final class CarouselView
    : UIView {
    
    private final let TAG = "CarouselView"
    
    public static let mTYPE_B = "b"
    public static let mTYPE_M = "m"
    
    private var mCarousels: [Carousel] = []
    private var mCollectionViews: [CarouselCollectionView] = []
    
    private var mSpacing: CGFloat = 0
    
    private var mTimer: Timer? = nil
    
    init(
        carousels: [Carousel],
        space: CGFloat,
        frame: CGRect
    ) {
        mCarousels = carousels
        super.init(
            frame: frame
        )
        
        backgroundColor = .blue
        
        let w = frame.width
        let htable = frame.height
        mSpacing = space
                
        var y:CGFloat = 0
        
        for i in 0..<mCarousels.count {
            
            let c = mCarousels[i]
            mCarousels[i].from = c.cellSize.width * 5 * c.from
        
            let cv = CarouselCollectionView(
                type: c.type,
                cellSize: c.cellSize,
                frame: CGRect(
                    x: -space,
                    y: y,
                    width: w+space*2,
                    height: c.cellSize.height
                )
            )
            
            cv.tag = 1
            
            /*cv.setContentOffset(
                CGPoint(
                    x: c.from,
                    y: 0
                ),
                animated: true
            )*/
            
            cv.backgroundColor = .clear
            
            cv.register(
                UICollectionViewCell.self,
                forCellWithReuseIdentifier: c.type
            )
                    
            addSubview(cv)
                    
            cv.delegate = self
            cv.dataSource = self
            
            mCollectionViews.append(cv)
            
            y += c.cellSize.height + mSpacing
            
        }
        
    }
    
    public func stop() {
        mTimer?.invalidate()
        mTimer = nil
    }
    
    public func start() {
        return
        var p = CGPoint(
            x:0,
            y:0
        )
        mTimer = Timer.scheduledTimer(
            withTimeInterval: 0.01,
            repeats: true
        ) { _ in
            
            for i in 0..<self.mCarousels.count {
                
                let c = self
                    .mCarousels[i]
                
                p.x = c.from
                
                self.mCarousels[i]
                    .from += c.delta
                
                self.mCollectionViews[i].setContentOffset(
                    p,
                    animated: false
                )
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(
            coder: coder
        )
    }
    
    public struct Carousel {
        var cellSize: CGSize
        var type: String
        var from: CGFloat
        var delta: CGFloat
    }

}

extension CarouselView
    : UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        print(TAG, "sectionCount: 8")
        return 8
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let i = indexPath.row
        
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: ImageViewCell.id,
                for: indexPath
        ) as! ImageViewCell
        
        let imgid = collectionView.tag
        collectionView.tag += 1
        if collectionView.tag > 3 {
            collectionView.tag = 1
        }
        
       
        let w = UIScreen
            .main
            .bounds
            .width
        
        let type = cell.frame.width > w * 0.8 ? 1 : 2
        
        print(TAG, "TAG:",type,imgid,collectionView.tag)
        
        
        cell.mImageView.image = UIImage(
            named: "\(type)\(imgid)"
        )
        
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = cell.frame.height * 0.12
        
        return cell
    }
}

extension CarouselView
    : UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let s = (collectionView as! CarouselCollectionView
        ).mCellSize
        
        print(TAG, "cell size:", s)
        return s
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return mSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return mSpacing
    }
    
}

