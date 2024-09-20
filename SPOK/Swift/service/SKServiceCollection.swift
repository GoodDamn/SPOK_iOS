//
//  SKServiceCollection.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
import FirebaseStorage

final class SKServiceCollection {
    
    private static let maxSize: Int64 = 10 * 1024
    
    weak var delegate: SKDelegateCollection? = nil
    
    private final let mReference = Storage
        .storage()
        .reference(
            withPath: "Sleep/ru.scc"
        )
    
    private final let mServiceCache = SKServiceCache(
        fileName: "0.scc",
        dirName: "cls"
    )
    
    private var mUpdateTime = 0
    
    final func getCollectionAsync(
        offset: Int = 0,
        len: Int = 3
    ) {
        if !mServiceCache.isEmpty() {
            DispatchQueue.io { [weak self] in
                guard let self = self else {
                    return
                }
                
                let d = self.mServiceCache.getData()
                if var collections = d?.scc() {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.onGetCollections(
                            collections: &collections
                        )
                    }
                }
            }
        }
        
        mReference.getMetadata { [weak self]
            meta, error in
            guard let meta = meta,
                error == nil else {
                return
            }
            self?.onGetMetadata(
                meta: meta
            )
        }
    }
    
    private final func onGetMetadata(
        meta: StorageMetadata
    ) {
        guard let updatedTime = meta
            .updated?
            .timeIntervalSince1970 else {
            return
        }
        
        mUpdateTime = Int(
            updatedTime
        )
        
        if mServiceCache.isValidCache(
            time: mUpdateTime
        ) {
            return
        }
        
        mReference.getData(
            maxSize: SKServiceCollection.maxSize
        ) { [weak self] data, error in
            
            guard var data = data,
                error == nil else {
                return
            }
            DispatchQueue.io { [weak self] in
                self?.onGetData(
                    data: &data
                )
            }
        }
    }
    
    
    private final func onGetData(
        data: inout Data
    ) {
        guard var collections = data.scc() else {
            return
        }
        
        mServiceCache.writeData(
            data: &data
        )
        
        mServiceCache.setLastModified(
            time: mUpdateTime
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onGetCollections(
                collections: &collections
            )
        }
    }
    
}
