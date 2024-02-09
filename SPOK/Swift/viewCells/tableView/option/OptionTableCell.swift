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
    
    private var mViewPrimary: UIView? = nil
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
        
        mLabelTitle = UILabel()
        
        mLabelTitle.font = UIFont(
            name: "OpenSans-SemiBold",
            size: 1
        )
        
        mLabelTitle.textColor = .white
        
        backgroundColor = .clear
        mImageViewIcon.backgroundColor =
            .clear
        
        mLabelTitle.backgroundColor =
            .clear
        
        mImageViewIcon.tintColor = UIColor
            .accent()
        
        
        contentView.addSubview(
            mImageViewIcon
        )
        
        contentView.addSubview(
            mLabelTitle
        )
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if selectionStyle == .none  {
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
    
    func primaryView(
        view: UIView?
    ) {
        if mViewPrimary != nil {
            return
        }
        
        guard let v = view else {
            
            let primar = UIImageView()
            
            primar.tintColor = .gray
            
            primar.backgroundColor =
                .clear
            
            primar.image = UIImage(
                systemName: "chevron.right"
            )
            
            contentView.addSubview(
                primar
            )
            
            let f = mImageViewIcon.frame
            let imageSize = f.width
            
            primar.frame = CGRect(
                x: frame.width - imageSize,
                y: f.origin.y,
                width: imageSize * 0.5,
                height: imageSize * 0.75
            )
            
            mViewPrimary = primar
            return
        }
         
        print("primaryView:VIEW:",view)
        
        let ymid = frame.size.height * 0.5
        let f = v.frame
        
        v.frame = CGRect(
            x: frame.width - f.width,
            y: ymid - f.height * 0.5,
            width: f.width,
            height: f.height
        )
        
        contentView.addSubview(
            v
        )
        
        mViewPrimary = v
    }
    
}
