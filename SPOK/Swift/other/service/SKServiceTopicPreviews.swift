//
//  SKServiceTopicPreviews.swift
//  SPOK
//
//  Created by GoodDamn on 29/08/2024.
//

import Foundation
import FirebaseStorage

final class SKServiceTopicPreviews {
    
    private static let maxSize: Int64 = 3 * 1024 * 1024
    
    private let mReference = Storage
        .storage()
        .reference(
            withPath: "Trainings"
        )
    
    private var mReferenceTopic: StorageReference? = nil
    
    private let mServiceCache = SKServiceCache(
        dirName: "prs"
    )
    
    private var mUpdateTime = 0
    
    final func getTopicPreview(
        id: Int,
        type: CardType
    ) {
        let fileName = "\(type.rawValue).spc"
        mReferenceTopic = mReference.child(
            String(id)
        ).child(
            fileName
        )
        
        mServiceCache.setFile(
            fileName: "\(id)\(fileName)",
            dirName: "prs"
        )
        
        mReferenceTopic?.getMetadata {
            [weak self] meta, error in
            
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
        
        mReferenceTopic?.getData(
            maxSize: SKServiceTopicPreviews.maxSize
        ) { [weak self] data, error in
            guard var data = data, error == nil else {
                return
            }
            
            self?.onGetData(
                data: &data
            )
        }
    }
 
    private final func onGetData(
        data: inout Data
    ) {
        guard let topic = data.spc() else {
            return
        }
        
        
    }
    
}
