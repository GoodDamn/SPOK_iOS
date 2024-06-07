//
//  OptionTableCell.swift
//  SPOK
//
//  Created by GoodDamn on 08/02/2024.
//

import Foundation
import UIKit.UITableViewCell

final class OptionTableCell
    : UIViewListenable {
    
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
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        
        let (imageSize, yimage) =
            tempCalc()
        
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
                x: imageSize*2,
                y: yimage,
                width: frame.width - imageSize*2,
                height: imageSize
            )
        )
        
        mLabelTitle.font = .semibold(
            withSize: imageSize * 0.7
        )
        
        mLabelTitle.textColor = .white
        
        backgroundColor = .clear
        
        mImageViewIcon.backgroundColor =
            .clear
        
        mLabelTitle.backgroundColor =
            .clear
        
        mImageViewIcon.tintColor = .accent()
        
        addSubview(
            mImageViewIcon
        )
        
        addSubview(
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
    
    func primaryView(
        view: UIView?
    ) {
        if mViewPrimary != nil {
            return
        }
        
        guard let v = view else {
            
            let (imageSize, yimage) =
                tempCalc()
            
            let primar = UIImageView(
                frame: CGRect(
                    x: frame.width - imageSize,
                    y: yimage,
                    width: imageSize * 0.5,
                    height: imageSize * 0.75
                )
            )
            
            primar.tintColor = .gray
            
            primar.backgroundColor =
                .clear
            
            primar.image = UIImage(
                systemName: "chevron.right"
            )
            
            addSubview(
                primar
            )
            
            mViewPrimary = primar
            return
        }
        
        let ymid = frame.size.height * 0.5
        let f = v.frame
        
        v.frame = CGRect(
            x: frame.width - f.width,
            y: ymid - f.height * 0.5,
            width: f.width,
            height: f.height
        )
        
        addSubview(
            v
        )
        
        mViewPrimary = v
    }
    
    private func tempCalc() -> (
        imageSize: CGFloat,
        yimage: CGFloat
    ) {
        let size = frame.size
        let w = size.width
        
        let imageSize = size.height * 0.45
        let yimage = (size.height - imageSize) * 0.5
        
        return (
            imageSize: imageSize,
            yimage: yimage
        )
    }
    
}
