//
//  Cache.swift
//  SPOK
//
//  Created by GoodDamn on 28/01/2024.
//

import Foundation
import FirebaseStorage

class Cache<T> {
    
    weak var delegate: CacheListener? = nil
    var object: T? = nil
    
    internal let mReference: StorageReference
    internal let mPathToSave: String
    internal let mUrlToSave: URL
    internal let mIsDir: Bool
    
    init(
        pathStorage: String,
        localPath: URL,
        isDirectory: Bool = false
    ) {
        mIsDir = isDirectory
        
        mReference = Storage
            .storage()
            .reference(
                withPath: pathStorage
            )
        
        mPathToSave = localPath.pathh()
        mUrlToSave = localPath
        print(
            "Cache: URL_TO_SAVE:",
            mUrlToSave
        )
    }
    
    internal func checkMeta(
        childRef: String = ""
    ) {
        if !MainViewController
            .mIsConnected {
            onCacheNotExpired()
            return
        }
        
        // Checking metadata first
        mReference
            .child(childRef)
            .getMetadata { [weak self]
                meta, error in
                
                guard let meta = meta,
                      error == nil else {
                    
                    self?.delegate?
                        .onError()
                    
                    print(
                        "Cache:",
                        "ERROR_META:",
                        error
                    )
                    return
                }
                
                self?.processMeta(
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
            "Cache",
            "cacheTime:",
            localTime,
            netTime,
            mPathToSave
        )
        
        if localTime >= netTime {
            onCacheNotExpired()
            return
        }
        
        if mIsDir {
            StorageApp
                .mkdir(
                    path: mPathToSave
                )
            
            StorageApp
                .modifTime(
                    path: mPathToSave,
                    time: netTime
                )
        }
        
        print(
            "Cache",
            "TIME TO CACHE UPDATE!"
        )
        
        onUpdateCache()
    }
    
    func onUpdateCache() {}
    func onCacheNotExpired() {}
}
