//
//  OptionTableCell.swift
//  SPOK
//
//  Created by GoodDamn on 08/02/2024.
//

import Foundation
import UIKit.UITableViewCell

final class OptionTableCell
    : InversedTableViewCell {
    
    public static let id = "option"
    
    public var image: UIImage? {
        didSet {
            mImageViewIcon.image = image
        }
    }
    
    public var textColorr: UIColor? = nil {
        didSet {
            mLabelTitle.textColor = textColorr
        }
    }
    
    public var iconColor: UIColor? = nil {
        didSet {
            mImageViewIcon.tintColor =
                iconColor
        }
    }
    
    public var text: String? {
        didSet {
            mLabelTitle.text = text
        }
    }
    
    private var mImageViewArrow: UIImageView!
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
        
        mImageViewIcon = UIImageView()
        mImageViewArrow = UIImageView()
        
        mLabelTitle = UILabel()
        
        mLabelTitle.font = UIFont(
            name: "OpenSans-SemiBold",
            size: 1
        )
        
        mLabelTitle.textColor = .white
        
        backgroundColor = .clear
        mImageViewIcon.backgroundColor =
            .clear
        mImageViewArrow.backgroundColor =
            .clear
        mLabelTitle.backgroundColor =
            .clear
        
        mImageViewIcon.tintColor = UIColor
            .accent()
        mImageViewArrow.tintColor = .gray
        
        mImageViewArrow.image = UIImage(
            systemName: "chevron.right"
        )
        
        contentView.addSubview(
            mImageViewIcon
        )
        
        contentView.addSubview(
            mLabelTitle
        )
        
        contentView.addSubview(
            mImageViewArrow
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if selectionStyle == .none {
            return
        }
        
        let size = frame.size
        
        let w = size.width
        
        let imageSize = size.height * 0.45
        let ymid = size.height * 0.5
        let yimage = ymid - imageSize * 0.5
        
        mImageViewIcon.frame = CGRect(
            x: 0,
            y: yimage,
            width: imageSize,
            height: imageSize
        )
        
        mImageViewArrow.frame = CGRect(
            x: w - imageSize,
            y: yimage,
            width: imageSize * 0.5,
            height: imageSize * 0.75
        )
        
        mLabelTitle.frame = CGRect(
            x: imageSize*2,
            y: yimage,
            width: w - imageSize*2,
            height: imageSize
        )
        
        
        mLabelTitle.font = mLabelTitle
            .font.withSize(
                imageSize * 0.7
            )
        
        selectionStyle = .none
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
    }
}
