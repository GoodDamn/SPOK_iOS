//
//  CacheFile.swift
//  SPOK
//
//  Created by GoodDamn on 20/01/2024.
//

import Foundation
import FirebaseStorage

class CacheFile<T>
    : CacheFileHandler {
    
    weak var delegate: CacheListener? = nil
    var object: T? = nil
    
    internal let mReference: StorageReference
    internal let mPathToSave: String
    internal let mUrlToSave: URL
    internal let mWithCache: Bool
    internal let mBackgroundLoad: Bool
    internal var mFirstLoad: Bool = true
    
    deinit {
        print("CacheFile:deinit()")
    }
    
    init(
        pathStorage: String,
        localPath: URL,
        withCache: Bool = false,
        backgroundLoad: Bool = false
    ) {
        mWithCache = withCache
        mBackgroundLoad = backgroundLoad
        
        mReference = Storage
            .storage()
            .reference(
                withPath: pathStorage
            )
        
        mPathToSave = localPath.pathh()
        mUrlToSave = localPath
        print(
            "CacheFile: URL_TO_SAVE:",
            mUrlToSave
        )
    }
    
    public func load() {
        let networkAvailable = true
        
        loadCache()
        if !networkAvailable {
            return
        }
        
        // Checking metadata first
        mReference.getMetadata { [weak self]
            meta, error in
            
            guard let meta = meta,
                  error == nil else {
                
                self?.delegate?
                    .onError()
                
                print(
                    "CacheFile:",
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

    private func loadCache() {
        let exists = StorageApp.exists(
            at: mPathToSave
        )
        
        mFirstLoad = !exists
        
        if mFirstLoad {
            return
        }
        
        DispatchQueue.global(
            qos: .default
        ).async {
            var cache = StorageApp
                .file(
                    path: self.mPathToSave
                )
            self.delegate?.onFile(
                data: &cache
            )
        }
        
    }
    
    func onUpdateCache() {}
    
}
