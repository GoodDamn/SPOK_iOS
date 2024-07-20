//
//  CacheFile.swift
//  SPOK
//
//  Created by GoodDamn on 20/01/2024.
//

import Foundation
import FirebaseStorage

class CacheFile<T>
    : Cache<T>,
      CacheFileHandler {
    
    internal let mWithCache: Bool
    internal let mBackgroundLoad: Bool
    internal var mFirstLoad: Bool = true
    
    deinit {
        Log.d("CacheFile:deinit()")
    }
    
    init(
        pathStorage: String,
        localPath: URL,
        withCache: Bool = false,
        backgroundLoad: Bool = false
    ) {
        mWithCache = withCache
        mBackgroundLoad = backgroundLoad
        
        super.init(
            pathStorage: pathStorage,
            localPath: localPath,
            isDirectory: false
        )
    }
    
    public func load() {
        loadCache()
        checkMeta()
    }
    
    private func loadCache() {
        let exists = StorageApp.exists(
            at: mPathToSave
        )
        
        mFirstLoad = !exists
        
        if mFirstLoad {
            return
        }
        
        
        var cache = StorageApp
            .file(
                path: mPathToSave
            )
        delegate?.onFile(
            data: &cache
        )
        
        /*DispatchQueue.io { [weak self] in
            
            
        }*/
        
    }
    
    override func onUpdateCache() {}
    
}
