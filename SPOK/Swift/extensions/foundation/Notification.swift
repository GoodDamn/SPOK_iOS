//
//  Notification.swift
//  SPOK
//
//  Created by GoodDamn on 08/08/2024.
//

import Foundation
import UIKit.UIResponder

extension Notification {
    
    func keyboardFrame() -> CGRect {
        
        guard let keyFrame = userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? NSValue else {
            return .zero
        }
        
        return keyFrame.cgRectValue
    }
    
}
