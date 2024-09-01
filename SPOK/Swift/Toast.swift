//
//  Toast.swift
//  SPOK
//
//  Created by Cell on 15.12.2021.
//

import UIKit;

final class Toast {
    
    static func show(
        text: String
    ) {
        
        let c = UIAlertController(
            title: text,
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
