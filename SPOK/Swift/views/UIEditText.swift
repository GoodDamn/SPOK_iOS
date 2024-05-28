//
//  UITextInput.swift
//  SPOK
//
//  Created by GoodDamn on 27/05/2024.
//

import Foundation
import UIKit

final class UIEditText
    : UITextField {
    
    private var mPadding = UIEdgeInsets(
        top: 0,
        left: 5,
        bottom: 0,
        right: 5
    )
 
    override init(
        frame: CGRect
    ) {
        mPadding.left = frame.width * 0.1
        mPadding.right = mPadding.left
        super.init(
            frame: frame
        )
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
    }
    
    override func textRect(
        forBounds bounds: CGRect
    ) -> CGRect {
        return bounds.inset(
            by: mPadding
        )
    }
    
    override func placeholderRect(
        forBounds bounds: CGRect
    ) -> CGRect {
        return bounds.inset(
            by: mPadding
        )
    }
    
    override func editingRect(
        forBounds bounds: CGRect
    ) -> CGRect {
        return bounds.inset(
            by: mPadding
        )
    }
    
}
