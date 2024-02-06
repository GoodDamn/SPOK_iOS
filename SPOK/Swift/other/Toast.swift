//
//  Toast.swift
//  SPOK
//
//  Created by Cell on 15.12.2021.
//

import Foundation;
import UIKit;

class Toast {
    
    private var mText: String
    private var mDuration: Double
    
    init(
        text: String,
        duration: Double
    ) {
        mText = text;
        mDuration = duration;
    }
    
    public func show() {
        
        let c = UIAlertController(
            title: mText,
            message: nil,
            preferredStyle: .alert
        )
        
        c.addAction(UIAlertAction(
            title: "OK",
            style: .default)
        )
        
        Utils.main()
            .present(
                c,
                animated: true
            )
        
    }
}
