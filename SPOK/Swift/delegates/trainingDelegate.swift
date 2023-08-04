//
//  trainingDelegate.swift
//  SPOK
//
//  Created by Cell on 17.04.2022.
//

import UIKit;
class trainingDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! MCellCollectionView;
        
        cell.nameTraining.text = indexPath.row.description;
        cell.descriptionTr.text = "Description of " + indexPath.row.description;
        
        cell.imageViewTraining.image = UIImage(named: "apple_icon");
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MCellCollectionView;
        print(cell.nameTraining.text! + " is started");
    }
}
