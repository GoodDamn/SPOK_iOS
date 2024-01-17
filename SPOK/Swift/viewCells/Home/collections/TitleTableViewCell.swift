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
    
    public var mTitle: UILabel? = nil
    
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
        print("TitleTableViewCell: init()")
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        ini()
    }
    
    required init?(coder: NSCoder) {
        print("TitleTableViewCell: init(NSCoder)")
        super.init(coder: coder)
        ini()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        print("TitleTableViewCell: layoutSubviews()")
        
        let w = frame.width
        let s = 0.1 * w
        
        mTitle?.frame = CGRect(
            x: s,
            y: 0,
            width: w-s,
            height: mTitle?.frame.height ?? 15
        )
        
        print("TitleTableViewCell","LFRAME:", mTitle?.frame)
        
    }
    
}
