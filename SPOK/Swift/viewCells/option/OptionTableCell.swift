//
//  OptionTableCell.swift
//  SPOK
//
//  Created by GoodDamn on 08/02/2024.
//

import Foundation
import UIKit.UITableViewCell

final class OptionTableCell
    : UITableViewCell {
    
    public static let id = "option"
    
    public var image: UIImage? {
        didSet {
            mImageViewIcon.image = image
        }
    }
    
    public var text: String? {
        didSet {
            mLabelTitle.text = text
        }
    }
    
    private var mImageViewIcon: UIImageView!
    private var mLabelTitle: UILabel!
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        let imageSize = frame.height * 0.5
        let yimage = imageSize * 0.5
        
        mImageViewIcon = UIImageView(
            frame: CGRect(
                x: 0,
                y: yimage,
                width: imageSize,
                height: imageSize
            )
        )
        
        mLabelTitle = UILabel(
            frame: CGRect(
                x: imageSize,
                y: yimage,
                width: frame.width - imageSize,
                height: imageSize
            )
        )
        
        mLabelTitle.font = UIFont(
            name: "OpenSans-SemiBold",
            size: imageSize
        )
        
        mLabelTitle.textColor = .white
        
        backgroundColor = .clear
        mImageViewIcon.backgroundColor = .clear
        mLabelTitle.backgroundColor =
            .clear
        
        contentView.addSubview(
            mImageViewIcon
        )
        
        contentView.addSubview(
            mLabelTitle
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
