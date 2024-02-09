//
//  InversedTableView.swift
//  SPOK
//
//  Created by GoodDamn on 09/02/2024.
//

import Foundation
import UIKit.UITableView

class InversedTableView
    : UITableView {
    
    override init(
        frame: CGRect,
        style: UITableView.Style
    ) {
        super.init(
            frame: frame,
            style: style
        )
        
        transform = CGAffineTransform(
            scaleX: 1,
            y: -1
        )
        
    }
    
}
