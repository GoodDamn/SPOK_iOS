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
    
    final func getCollectionAsync(
        offset: Int = 0,
        len: Int = 3
    ) {
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
        mReference.getData(
            maxSize: SKServiceCollection.maxSize
        ) { [weak self] data, error in
            
            guard let data = data,
                error == nil else {
                return
            }
            
            self?.onGetData(
                data: data
            )
        }
    }
    
    
    private final func onGetData(
        data: Data
    ) {
        var d = data
        guard var collections = d.scc() else {
            return
        }
        
        delegate?.onGetCollections(
            collections: &collections
        )
    }
    
}
