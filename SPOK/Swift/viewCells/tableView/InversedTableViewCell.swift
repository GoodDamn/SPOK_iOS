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
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        contentView
            .transform = CGAffineTransform(
                scaleX: 1,
                y: -1
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
