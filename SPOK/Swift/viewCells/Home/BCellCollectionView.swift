//
//  BCellCollectionView.swift
//  SPOK
//
//  Created by Cell on 13.11.2022.
//

import UIKit;
class BCellCollectionView:MCellCollectionView{
    
    func load(view: UIViewController,id:Int, _ controller: UIViewController, manager: ManagerViewController, lang:String="") {
        load(id: id,
             controller: controller,
             manager: manager,
             type: StorageApp.bCardChild,
             lang:lang,
             nameSize: 23.0,
             descSize: 11.3);
    }
    
}
