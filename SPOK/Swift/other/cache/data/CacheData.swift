//
//  CacheData.swift
//  SPOK
//
//  Created by GoodDamn on 27/01/2024.
//

import Foundation


class CacheData<T>
    : CacheFile<T> {
    
    override func onUpdateCache() {
        // Update cache or create
        mReference.getData(
            maxSize: 1024*1024
        ) { data, error in
            
            if error != nil {
                print(
                    "CacheFile",
                    "ERROR_DATA:",
                    error
                )
                return
            }
            
            DispatchQueue
                .global(
                    qos: .default
                )
                .async {
                    
                    var data = data
                    
                    // Send new data
                    self.delegate?.onNet(
                        data: &data
                    )
                }
        }
    }
    
}
