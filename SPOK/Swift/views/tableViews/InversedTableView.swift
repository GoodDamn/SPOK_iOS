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
    
    public var inversed: Bool = false {
        didSet {
            transform = CGAffineTransform(
                scaleX: 1,
                y: inversed ? -1 : 1
            )
        }
    }
    
    override init(
        frame: CGRect,
        style: UITableView.Style
    ) {
        super.init(
            frame: frame,
            style: style
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
