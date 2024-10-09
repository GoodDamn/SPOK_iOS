//
//  SKServiceTopicContent.swift
//  SPOK
//
//  Created by GoodDamn on 30/08/2024.
//

import Foundation
import FirebaseStorage

final class SKServiceTopicContent {
    
    private static let DIR = "mp3"
    private static let maxSize: Int64 = 50 * 1024 * 1024
    
    private let mReference = Storage
        .storage()
        .reference(
            withPath: "content/mp3"
        )
    
    weak var onProgressDownload: SKDelegateOnProgressDownload? = nil
    
    weak var onGetTopicContent: SKDelegateOnGetTopicContent? = nil
    
    weak var onGetTopicUrl: SKListenerOnGetContentUrl? = nil
    
    private var mCurrentTask: StorageDownloadTask? = nil
    
    private var mReferenceFull: StorageReference? = nil
    
    private let mServiceCache = SKServiceCache(
        dirName: SKServiceTopicContent
            .DIR
    )
    
    private var mUpdateTime = 0
    
    final func getContentUrlAsync(
        id: Int
    ) {
        mReferenceFull = mReference.child(
            "\(id).mp3"
        )
        
        mReferenceFull?.downloadURL {
            [weak self] url, error in
            
            guard let url = url, error == nil else {
                return
            }
            
            self?.onGetTopicUrl?.onGetContentUrl(
                url: url
            )
            
        }
    }
    
    final func getContent(
        id: Int
    ) {
        let fileName = "\(id).mp3"
        mServiceCache.setFile(
            fileName: fileName,
            dirName: SKServiceTopicContent
                .DIR
        )
        
        if !mServiceCache.isEmpty() {
            onProgressDownload?
                .onProgressDownload(
                progress: 0.99
            )
            onGetTopicContent?
                .onGetTopicContent(
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
    
    
    final func cancelTask() {
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
        
        mCurrentTask = mReferenceFull?.getData(
            maxSize: SKServiceTopicContent.maxSize
        ) { [weak self] data, error in
            guard var data = data, error == nil else {
                return
            }
            self?.onGetData(
                data: &data
            )
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
        
        onProgressDownload?
            .onProgressDownload(
            progress: CGFloat(
                progress.fractionCompleted
            )
        )
    }
    
    private final func onGetData(
        data: inout Data
    ) {
        
        mServiceCache.writeData(
            data: &data
        )
        
        mServiceCache.setLastModified(
            time: mUpdateTime
        )
        
        onGetTopicContent?.onGetTopicContent(
            model: SKModelTopicContent(
                data: data
            )
        )
    }
    
}
