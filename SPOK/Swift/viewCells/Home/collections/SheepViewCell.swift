//
//  SheepViewCell.swift
//  SPOK
//
//  Created by GoodDamn on 16/01/2024.
//

import Foundation
import UIKit

public class SheepViewCell
    : TitleTableViewCell {
    
    private static let TAG = "SheepViewCell:"
    public static let id = "sheep"
    
    public var mBtnBegin: UIButton?
    private var mSheep: Sheep?
    private var moon: UIImageView?
    
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
            .button(
                text: "НАЧАТЬ"
            )
        
        moon = UIImageView()
        moon?.image = UIImage(
            named: "moon 1"
        )
        moon?.backgroundColor = .clear
        
        mSheep = Sheep(
            frame: .zero
        )
        
        if let beg = mBtnBegin {
            contentView
                .addSubview(beg)
        }
        
        if let sheep = mSheep {
            contentView
                .addSubview(sheep)
        }
        
        if let moon = moon {
            contentView
                .addSubview(moon)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(
            coder: coder
        )
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        print("SheepViewCell: calculated:", mIsCalculated)
        
        if mIsCalculated {
            return
        }
        
        let w = frame.width
        let h = frame.height
        
        let mb = w * 0.135
        let off = w * 0.07
        
        moon?.frame = CGRect(
            x: w-mb-off,
            y: off,
            width: mb,
            height: mb
        )
        
        let b = 0.345 * w
        mSheep?.frame = CGRect(
            x: (w-b) * 0.5,
            y: (h-b) * 0.5 - h * 0.1,
            width: b,
            height: b
        )
        
        LayoutUtils.button(
            for: mBtnBegin,
            frame,
            y: 0.7,
            width: 0.62,
            height: 0.15,
            cornerRadius: 0.5,
            textSize: 0.4
        )
        
        mIsCalculated = true
    }
    
}
