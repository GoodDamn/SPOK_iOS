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
    
    @IBOutlet weak var collectionView: UICollectionView!;
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        print("CollectionTableViewCell: init()")
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
    }
    
    required init?(coder: NSCoder) {
        print("CollectionTableViewCell: init(CODER)")
        super.init(coder:coder)
    }
    
}
