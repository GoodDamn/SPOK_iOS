//
//  OneShotViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class OneShotViewController
    : DelegateViewController {
    
    public var onEndTimer: (()->Void)? = nil
    
    open func startTimer(
        duration: TimeInterval
    ) {
        
        DispatchQueue
            .main
            .asyncAfter(
                deadline: .now() + duration
            ) {
                self.onEndTimer?()
            }
    }
    
}
