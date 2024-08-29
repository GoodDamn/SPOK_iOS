//
//  TitleCollectionViewCell.swift
//  SPOK
//
//  Created by GoodDamn on 17/01/2024.
//

import Foundation
import UIKit

class UITableViewCellTitle
: UITableViewCell {
    
    private(set) var mTitle: UILabel? = nil
        
    private func ini() {
        mTitle = UILabel()
        guard let it = mTitle else {
            return
        }
        
        it.font = .extrabold(
            withSize: 18
        )
        
        it.numberOfLines = 1
        it.textColor = .white
        contentView.addSubview(
            it
        )
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        ini()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ini()
    }
    
    final func calculateBoundsTitle(
        with size: CGSize
    ) {
        let w = size.width
        let s = 0.053 * w
        
        if let it = mTitle {
            it.font = it.font.withSize(
                size.height * 0.1056
            )
            it.sizeToFit()
            it.frame = CGRect(
                x: s,
                y: 0,
                width: it.width(),
                height: it.height()
            )
        }
    }
    
}
