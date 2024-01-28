//
//  CacheListener.swift
//  SPOK
//
//  Created by GoodDamn on 27/01/2024.
//

import Foundation

public protocol CacheListener
    : AnyObject {
    
    func onError()
    
    func onFile(
        data: inout Data?
    )
    
    func onNet(
        data: inout Data?
    )
}
