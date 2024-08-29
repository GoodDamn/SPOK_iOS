//
//  SheepViewCell.swift
//  SPOK
//
//  Created by GoodDamn on 16/01/2024.
//

import Foundation
import UIKit

class SheepViewCell
    : UITableViewCellTitle {
    
    private static let TAG = "SheepViewCell:"
    static let id = "sheep"
    
    var mBtnBegin: UITextButton!
    private var mSheep: Sheep!
    private var moon: UIImageView!
    
    private var mIsCalculated = false
    
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
            .textButton(
                text: "НАЧАТЬ"
            )
        
        moon = UIImageView()
        moon.image = UIImage(
            named: "moon 1"
        )
        moon.backgroundColor = .clear
        
        mSheep = Sheep(
            frame: .zero
        )
        
        contentView
            .addSubview(mBtnBegin)
        
        contentView
            .addSubview(mSheep)
        
        contentView
            .addSubview(moon)
    }
    
    required init?(coder: NSCoder) {
        super.init(
            coder: coder
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if mIsCalculated {
            return
        }
        
        let w = frame.width
        let h = frame.height
        
        let mb = w * 0.135
        let off = w * 0.07
        
        moon.frame = CGRect(
            x: w-mb-off,
            y: off,
            width: mb,
            height: mb
        )
        
        let b = 0.345 * w
        mSheep.frame = CGRect(
            x: (w-b) * 0.5,
            y: (h-b) * 0.5 - h * 0.1,
            width: b,
            height: b
        )
        
        LayoutUtils.textButton(
            for: mBtnBegin,
            size: frame.size,
            textSize: 0.025,
            paddingHorizontal: 0.02,
            paddingVertical: 0.04
        )
        
        LayoutUtils.textButton(
            for: mBtnBegin,
            size: frame.size,
            textSize: 0.07,
            paddingHorizontal: 0.3,
            paddingVertical: 0.08
        )
        
        mBtnBegin.corner(
            normHeight: 0.5
        )
        
        mBtnBegin.y(
            0.7,
            in: self
        )
        
        mBtnBegin.centerH(
            in: self
        )
        
        mIsCalculated = true
    }
    
}
