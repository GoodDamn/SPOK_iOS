//
//  SKDelegateOnProgressDownload.swift
//  SPOK
//
//  Created by GoodDamn on 30/08/2024.
//

import Foundation

protocol SKDelegateOnProgressDownload
: AnyObject {
    
    func onProgressDownload(
        progress: CGFloat
    )
    
}
