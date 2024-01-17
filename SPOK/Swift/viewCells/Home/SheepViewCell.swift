//
//  SheepViewCell.swift
//  SPOK
//
//  Created by GoodDamn on 16/01/2024.
//

import Foundation
import UIKit

class SheepViewCell
    : UITableViewCell {
    
    private static let TAG = "SheepViewCell:"
    public static let id = "sheep"
    
    public weak var mBtnBegin: UIButton?
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        selectionStyle = .none
        
        mBtnBegin = ViewUtils
            .button(
                text: "НАЧАТЬ"
            )
        
        contentView
            .addSubview(mBtnBegin!)
    }
    
    required init?(coder: NSCoder) {
        super.init(
            coder: coder
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        LayoutUtils.button(
            for: mBtnBegin,
            frame,
            y: 0.7,
            width: 0.5,
            height: 0.1,
            cornerRadius: 0.5,
            textSize: 0.3
        )
        
        
    }
    
}
