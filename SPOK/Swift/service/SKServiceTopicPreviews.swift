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
    
    weak var delegate: SKDelegateOnGetTopicPreview? = nil
    
    private var mReferenceTopic: StorageReference? = nil
    private var mUpdateTime = 0
    
    private let mReference = Storage
        .storage()
        .reference(
            withPath: "Trainings"
        )
    
    private let mServiceCache = SKServiceCache(
        dirName: "prs"
    )
    
    private var mCurrentTask: StorageDownloadTask? = nil
    
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
        
        if !mServiceCache.isEmpty() {
            DispatchQueue.io { [weak self] in
                guard let self = self else {
                    return
                }
                
                let d = self.mServiceCache.getData()
                if let topic = d?.spc() {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.onGetTopicPreview(
                            preview: topic
                        )
                    }
                }
            }
        }
        
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
    
    final func cancel() {
        mCurrentTask?.cancel()
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
        
        mCurrentTask = mReferenceTopic?.getData(
            maxSize: SKServiceTopicPreviews.maxSize
        ) { [weak self] data, error in
            guard var data = data, error == nil else {
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
        guard let topic = data.spc() else {
            return
        }
        
        mServiceCache.writeData(
            data: &data
        )
        
        mServiceCache.setLastModified(
            time: mUpdateTime
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onGetTopicPreview(
                preview: topic
            )
        }
    }
    
}
