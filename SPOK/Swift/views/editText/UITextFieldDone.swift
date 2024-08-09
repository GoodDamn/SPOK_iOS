//
//  UITextFieldDone.swift
//  SPOK
//
//  Created by GoodDamn on 09/08/2024.
//

import Foundation
import UIKit.UITextField

class UITextFieldDone
    : UITextField {
    
    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        delegate = self
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
        delegate = self
    }
    
}

extension UITextFieldDone
    : UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
