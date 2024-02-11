//
//  UIImage.swift
//  SPOK
//
//  Created by GoodDamn on 11/02/2024.
//

import Foundation
import UIKit.UIImage

extension UIImage {
    
    func crop(
        _ s: CGSize
    ) -> UIImage {
                
        guard let croppedimg = self
            .cgImage?
            .cropping(
                to: CGRect(
                    origin: .zero,
                    size: s
                )
            ) else {
            
            return self
        }
        
        
        return UIImage(
            cgImage: croppedimg
        )
    }
    
    func size(
        _ s: CGSize
    ) -> UIImage {
        
        var i = self;
        UIGraphicsBeginImageContext(s);
        i.draw(
            in: CGRect(
                origin: .zero,
                size: s)
        )
        i = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return i;
    }
    
}
