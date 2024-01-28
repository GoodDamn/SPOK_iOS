//
//  CacheFile.swift
//  SPOK
//
//  Created by GoodDamn on 20/01/2024.
//

import Foundation
import FirebaseStorage

class CacheFile<T, L: CacheListener>
    : CacheFileHandler {
    
    var delegate: L? = nil
    var object: T? = nil
    
    internal let mReference: StorageReference
    internal let mPathToSave: String
    internal let mUrlToSave: URL
    
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
        mUrlToSave = URL(
            string: mPathToSave
        )!
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
                    "CacheFile:",
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
            "CacheFile",
            "cacheTime:",
            localTime,
            netTime,
            mPathToSave
        )
        
        if localTime >= netTime {
            return
        }
        
        print(
            "CacheFile",
            "TIME TO CACHE UPDATE!"
        )
        
        onUpdateCache()

    }

    func onUpdateCache() {}
    
}
