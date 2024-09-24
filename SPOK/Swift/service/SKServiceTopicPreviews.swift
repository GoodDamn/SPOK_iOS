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
    
    private let mDir = "prs"
    
    weak var delegate: SKDelegateOnGetTopicPreview? = nil
    
    private var mReferenceTopic: StorageReference? = nil
    
    private let mReference = Storage
        .storage()
        .reference(
            withPath: "Trainings"
        )
    
    private let mServiceCache = SKServiceCache(
        dirName: ""
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
        
        let fullName = "\(id)\(fileName)"
        
        mServiceCache.setFile(
            fileName: fullName,
            dirName: mDir
        )
        
        if !mServiceCache.isEmpty() {
            DispatchQueue.io { [weak self] in
                let d = self?.mServiceCache.getData()
                guard let topic = d?.spc() else {
                    return
                }
                
                DispatchQueue.ui {
                    self?.delegate?.onGetTopicPreview(
                        preview: topic
                    )
                }
            }
        }
        
        // Capture fullName
        mReferenceTopic?.getMetadata {
            [weak self] meta, error in
            
            guard let meta = meta,
                error == nil else {
                return
            }
            
            self?.onGetMetadata(
                meta: meta,
                fullName: fullName
            )
        }
    }
    
    final func cancel() {
        mCurrentTask?.cancel()
    }
    
    private final func onGetMetadata(
        meta: StorageMetadata,
        fullName: String
    ) {
        guard let updatedTime = meta
            .updated?
            .timeIntervalSince1970 else {
            return
        }
        
        let updateTime = Int(
            updatedTime
        )
        
        mServiceCache.setFile(
            fileName: fullName,
            dirName: mDir
        )
        
        if mServiceCache.isValidCache(
            time: updateTime
        ) {
            return
        }
        
        // Capture fullName and updateTime
        mCurrentTask = mReferenceTopic?.getData(
            maxSize: SKServiceTopicPreviews.maxSize
        ) { [weak self] data, error in
            
            guard error == nil else {
                Log.d(error)
                return
            }
            
            DispatchQueue.io {
                guard var data = data else {
                    return
                }
                
                self?.onGetData(
                    data: &data,
                    updateTimeSec: updateTime,
                    fullName: fullName
                )
            }
        }
    }
 
    private final func onGetData(
        data: inout Data,
        updateTimeSec: Int,
        fullName: String
    ) {
        guard let topic = data.spc() else {
            return
        }
        
        mServiceCache.setFile(
            fileName: fullName,
            dirName: mDir
        )
        
        mServiceCache.writeData(
            data: &data
        )
        
        mServiceCache.setLastModified(
            time: updateTimeSec
        )
        
        DispatchQueue.ui { [weak self] in
            self?.delegate?.onGetTopicPreview(
                preview: topic
            )
        }
    }
    
}
