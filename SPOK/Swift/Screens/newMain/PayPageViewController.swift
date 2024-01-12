//
//  PayPageViewController.swift
//  SPOK
//
//  Created by GoodDamn on 12/01/2024.
//

import Foundation
import UIKit

class PayPageViewController
    : StackViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        let blurView = UIVisualEffectView(
            frame: view.frame
        )
        
        blurView.effect = UIBlurEffect(
            style: .systemUltraThinMaterial
        )
        
        blurView.alpha = 1.0
        
        view.addSubview(blurView)
    }
    
}
