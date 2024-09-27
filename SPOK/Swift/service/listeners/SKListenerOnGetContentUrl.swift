//
//  SKListenerOnGetContentUrl.swift
//  SPOK
//
//  Created by GoodDamn on 27/09/2024.
//

import Foundation

protocol SKListenerOnGetContentUrl
: AnyObject {
    
    func onGetContentUrl(
        url: URL
    )
    
}
