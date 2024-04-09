//
//  TitleCollectionViewCell.swift
//  SPOK
//
//  Created by GoodDamn on 17/01/2024.
//

import Foundation
import UIKit

public class TitleTableViewCell
    : UITableViewCell {
    
    private(set) var mTitle: UILabel? = nil
    
    private var mIsCalculated = false
    
    private func ini() {
        mTitle = UILabel()
       
        mTitle!.font = UIFont(
            name: "OpenSans-ExtraBold",
            size: 18
        )
        
        mTitle!.numberOfLines = 1
        
        mTitle!.textColor = .white
        
        contentView.addSubview(
            mTitle!
        )
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        Log.d("TitleTableViewCell: init()")
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        ini()
    }
    
    required init?(coder: NSCoder) {
        Log.d("TitleTableViewCell: init(NSCoder)")
        super.init(coder: coder)
        ini()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if mIsCalculated {
            return
        }
        
        Log.d("TitleTableViewCell: layoutSubviews()")
        
        let w = frame.width
        let s = 0.053 * w
        
        mTitle?.frame = CGRect(
            x: s,
            y: 0,
            width: w-s,
            height: mTitle?.frame.height ?? 15
        )
        
        Log.d(
            "TitleTableViewCell",
            "LFRAME:",
            mTitle?.frame
        )
        mIsCalculated = true
    }
    
}
