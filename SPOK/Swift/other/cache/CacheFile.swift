//
//  CacheFile.swift
//  SPOK
//
//  Created by GoodDamn on 20/01/2024.
//

import Foundation
import FirebaseStorage

class CacheFile {
    
    private static let TAG = "CacheFile:"
    
    var delegate: CacheListener? = nil
    
    private let mReference: StorageReference
    private let mPathToSave: String
    
    
    init(
        pathStorage: String,
        localPath: String
    ) {
        
        mReference = Storage
            .storage()
            .reference(
                withPath: pathStorage
            )
        
        mPathToSave = localPath
    }
    
    public func load() {
        
        if StorageApp.exists(
            at: mPathToSave
        ) {
            
            DispatchQueue
                .global(
                    qos: .default
                )
                .async {
                    var cache = StorageApp
                        .file(
                            path: self
                                .mPathToSave
                        )
                    
                    self.delegate?.onFile(
                        data: &cache
                    )
                }
        }
        
        // Checking metadata first
        
        mReference.getMetadata {
            meta, error in
            
            guard let meta = meta,
                  error == nil else {
                print(
                    CacheFile.TAG,
                    "ERROR_META:",
                    error
                )
                return
            }
            
            self.processMeta(
                meta
            )
        }
        
    }
    
    private func processMeta(
        _ meta: StorageMetadata
    ) {
        
        let localTime = StorageApp
            .modifTime(
                path: mPathToSave
            )
        
        let netTime = meta
            .updated?
            .timeIntervalSince1970 ?? 0
        
        print(
            CacheFile.TAG,
            "cacheTime:",
            localTime,
            netTime,
            mPathToSave
        )
        
        if localTime >= netTime {
            return
        }
        
        print(
            CacheFile.TAG,
            "TIME TO CACHE UPDATE!"
        )
        // Update cache or create
        
        mReference.getData(
            maxSize: 1024*1024
        ) { data, error in
            
            
            if error != nil {
                print(
                    CacheFile.TAG,
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
