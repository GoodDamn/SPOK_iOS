//
//  InversedTableCell.swift
//  SPOK
//
//  Created by GoodDamn on 09/02/2024.
//

import Foundation
import UIKit.UITableViewCell

class InversedTableViewCell
    : UITableViewCell {
    
    public var inversed: Bool = false {
        didSet {
            contentView.transform = CGAffineTransform(
                scaleX: 1,
                y: inversed ? -1 : 1
            )
        }
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
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
