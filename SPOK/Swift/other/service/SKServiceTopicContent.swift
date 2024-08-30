//
//  SKServiceTopicContent.swift
//  SPOK
//
//  Created by GoodDamn on 30/08/2024.
//

import Foundation
import FirebaseStorage

final class SKServiceTopicContent {
    
    private static let DIR = "skc"
    
    private let mReference = Storage
        .storage()
        .reference(
            withPath: "content/skc"
        )
    
    weak var delegateProgress: SKDelegateOnProgressDownload? = nil
    weak var delegate: SKDelegateOnGetTopicContent? = nil
    
    private var mCurrentTask: StorageDownloadTask? = nil
    
    private var mReferenceFull: StorageReference? = nil
    
    private let mServiceCache = SKServiceCache(
        dirName: SKServiceTopicContent
            .DIR
    )
    
    private var mUpdateTime = 0
    
    final func getContent(
        id: Int
    ) {
        let fileName = "\(id).skc"
        mServiceCache.setFile(
            fileName: fileName,
            dirName: SKServiceTopicContent
                .DIR
        )
        
        if !mServiceCache.isEmpty() {
            delegateProgress?.onProgressDownload(
                progress: 0.99
            )
            delegate?.onGetTopicContent(
                model: SKModelTopicContent(
                    data: mServiceCache.getData()
                )
            )
        }
        
        mReferenceFull = mReference.child(
            fileName
        )
        
        mReferenceFull?.getMetadata {
            [weak self] meta, error in
            guard let meta = meta, error == nil else {
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
        
        mCurrentTask = mReferenceFull?.write(
            toFile: mServiceCache.getPath()
        ) { [weak self] _, error in
            guard error == nil else {
                return
            }
            self?.onSuccessDownload()
        }
        
        mCurrentTask?.observe(
            .progress
        ) { [weak self] snapshot in
            self?.onProgress(
                snapshot: snapshot
            )
        }
    }
    
    
    private final func onProgress(
        snapshot: StorageTaskSnapshot
    ) {
        guard let progress = snapshot.progress else {
            return
        }
        
        delegateProgress?.onProgressDownload(
            progress: CGFloat(
                progress.fractionCompleted
            )
        )
    }
    
    private final func onSuccessDownload() {
        mServiceCache.setLastModified(
            time: mUpdateTime
        )
        
        delegate?.onGetTopicContent(
            model: SKModelTopicContent(
                data: mServiceCache.getData()
            )
        )
    }
    
}
