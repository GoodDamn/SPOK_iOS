//
//  ImageLabel.swift
//  SPOK
//
//  Created by GoodDamn on 14/02/2024.
//

import Foundation
import UIKit

final class ImageLabel
    : UIView {
    
    private let mLabel: UILabel
    private let mImageView: UIImageView
    
    final var imageColor: UIColor = .white {
        didSet {
            mImageView.tintColor = imageColor
        }
    }
    
    final var image: UIImage? = nil {
        didSet {
            mImageView.image = image
        }
    }
    
    final var textColor: UIColor = .white {
        didSet {
            mLabel.textColor = textColor
        }
    }
    
    final var font: UIFont? = nil {
        didSet {
            mLabel.font = font
        }
    }
    
    final var text: String = "" {
        didSet {
            mLabel.text = text
        }
    }
    
    override init(
        frame: CGRect
    ) {
        let subFrame = CGRect(
            origin: .zero,
            size: frame.size
        )
        
        mLabel = UILabel(
            frame: subFrame
        )
        
        mLabel.numberOfLines = 0
        mLabel.textAlignment = .center
        
        mImageView = UIImageView(
            frame: subFrame
        )
        super.init(
            frame: frame
        )
        
        addSubview(
            mLabel
        )
        
        addSubview(
            mImageView
        )
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        
        mLabel.sizeToFit()
        
        let imageSize = mLabel.frame.height
        
        mImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: imageSize,
            height: imageSize
        )
        
        mLabel.frame.origin.x = imageSize + 20
        
        frame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: mImageView.frame.width + mLabel.frame.width,
            height: imageSize
        )
        
    }
    
    required init?(coder: NSCoder) {
        mLabel = UILabel()
        mImageView = UIImageView()
        super.init(coder: coder)
    }
    
}
