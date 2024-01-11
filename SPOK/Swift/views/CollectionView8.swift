//
//  CollectionView8.swift
//  SPOK
//
//  Created by GoodDamn on 22/07/2023.
//

import UIKit;

class CollectionView8
    : UICollectionView {
    
    private let mLang = Utils.getLanguageCode();
    
    var mCellIdentifier:String? = nil;
    
    var mIDs:[UInt16] = [] {
        didSet {
            reloadData();
        }
    };
    var mContext:UIViewController? = nil;
    
    
    override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(
            frame: frame,
            collectionViewLayout: layout
        );
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        );
    }
    
    
    func start() {
        delegate = self;
        dataSource = self;
    }
}


extension CollectionView8
    : UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        print("CollectionView8: SIZE:",mIDs.count);
        
        if (mIDs.count > 8) {
            return 8;
        }
        
        return mIDs.count;
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let mCellIdentifier = mCellIdentifier else {
            return UICollectionViewCell();
        }
        
        var id:UInt16 = mIDs[mIDs.count - indexPath.row - 1];
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mCellIdentifier, for: indexPath) as! SCellCollectionView;
        
        cell.collectionView = collectionView;
        cell.tag = Int(id);
        cell.load(id: cell.tag,
                  nameSize: 15.0,
                  viewController: mContext,
                  type: StorageApp.mCardChild,
                  lang: mLang);
        cell.imageViewTraining.contentMode = .scaleAspectFill;
        cell.layer.cornerRadius = 15;
        print(self, "CELL LOADING", cell.nameTraining.text, id)
        return cell;
    }
    
}


extension CollectionView8
    : UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 150, height: 150);
    }
    
}
