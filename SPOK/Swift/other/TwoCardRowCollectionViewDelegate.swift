//
//  TwoCardRowCollectionViewDelegate.swift
//  SPOK
//
//  Created by Igor Alexandrov on 18.07.2022.
//

import UIKit;
import FirebaseDatabase;

class TwoCardRowCollectionViewDelegate
    : NSObject,
      UICollectionViewDataSource,
      UICollectionViewDelegate,
      UICollectionViewDelegateFlowLayout {
    
    private let tag:String = "TwoCardDelegate:";
    
    var singleTap:Selector? = nil;
    var doubleTap:Selector? = nil;
    var controller: UIViewController? = nil;
    var doShowButtonNothing: Bool = false;
    var insetSections: UIEdgeInsets = UIEdgeInsets(top: 80, left: 0, bottom: 50, right: 0);
    var ids:[UInt16] = [];
    
    private let insets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22);
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetSections;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.contentInset = insets;
        return ids.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if doShowButtonNothing && indexPath.row == ids.count-1{
            return CGSize(width: UIScreen.main.bounds.width-insets.left*2, height: 55);
        }
        let w = UIScreen.main.bounds.width/2.0-32;
        return CGSize(width: w, height: w*1.24);
    }

    private func setup(
        _ cell: MCellCollectionView,
        indexPath: IndexPath,
        _ collectionView: UICollectionView
    ) {
        let id = ids[ids.count-indexPath.row-1];
        cell.load(
            id: Int(id),
            lang: Utils.getLanguageCode(),
            nameSize: 15.0,
            descSize: 8.65
        );
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if doShowButtonNothing && indexPath.row == ids.count-1 {
            let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: "nothing",
                    for: indexPath
                );
            cell.layer.cornerRadius = cell.bounds.height/2;
            cell.layer.borderWidth = 2.8;
            cell.layer.borderColor = UIColor(named: "nothing")?.cgColor;
            return cell;
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! MCellCollectionView;
        
        cell.imageViewTraining.layer.cornerRadius = 15;
        cell.imageViewTraining.clipsToBounds = true;
        
        self.setup(cell, indexPath: indexPath, collectionView);

        return cell;
    }
    
}
