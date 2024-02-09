//
//  UIFont.swift
//  SPOK
//
//  Created by GoodDamn on 09/02/2024.
//

import UIKit.UIFont

extension UIFont {
    
    static func bold(
        withSize: CGFloat
    ) -> UIFont? {
        return UIFont(
            name: "OpenSans-Bold",
            size: withSize
        )
    }
    
    static func semibold(
        withSize: CGFloat
    ) -> UIFont? {
        return UIFont(
            name: "OpenSans-SemiBold",
            size: withSize
        )
    }
    
    static func extrabold(
        withSize: CGFloat
    ) -> UIFont? {
        return UIFont(
            name: "OpenSans-ExtraBold",
            size: withSize
        )
    }
    
    static func regular(
        withSize: CGFloat
    ) -> UIFont? {
        return UIFont(
            name: "OpenSans-Regular",
            size: withSize
        )
    }
}
