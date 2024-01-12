//
//  BCellCollectionView.swift
//  SPOK
//
//  Created by Cell on 13.11.2022.
//

import UIKit;
class BCellCollectionView
    : MCellCollectionView{
    
    func load(
        id:Int,
        lang:String=""
    ) {
        load(id: id,
             type: StorageApp.bCardChild,
             lang:lang,
             nameSize: 23.0,
             descSize: 11.3);
    }
    
}
