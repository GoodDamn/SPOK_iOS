//
//  CategoryView.swift
//  SPOK
//
//  Created by Cell on 20.04.2022.
//

import UIKit

class CategoryView: UIView {

    @IBOutlet weak var nameCategory: UILabel!;
    @IBOutlet weak var imgIcon: UIImageView!;
    @IBOutlet weak var butCategory: UIButton!;
    @IBOutlet weak var leadIcon: NSLayoutConstraint!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }

}
