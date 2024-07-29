//
//  CacheData.swift
//  SPOK
//
//  Created by GoodDamn on 27/01/2024.
//

import Foundation

final class CacheData<T>
    : CacheFile<T> {
    
    internal let maxSize:Int64 = 5 * 1024 * 1024
    
    override func onUpdateCache() {
        // Update cache or create
        mReference.getData(
            maxSize: maxSize
        ) { [weak self] data, error in
            
            if error != nil {
                self?.delegate?
                    .onError()
                Log.d(
                    "CacheFile",
                    "ERROR_DATA:",
                    error
                )
                return
            }
            var data = data
            
            DispatchQueue.io {
                // Send new data
                self?.delegate?.onNet(
                    data: &data
                )
            }
            
        }
    }
    
}
