//
//  CacheProgressListener.swift
//  SPOK
//
//  Created by GoodDamn on 27/01/2024.
//

import Foundation

protocol CacheProgressListener
    : CacheListener {
    
    func onWrittenStorage()
    
    func onProgress(
        percent: Double
    )
    
    func onSuccess()
    
    func onError()
    
}
