//
//  CollectionDownloader.swift
//  SPOK
//
//  Created by GoodDamn on 13/01/2024.
//

import Foundation
import FirebaseStorage
import UIKit

class CollectionDowloader {
    
    private final let TAG = "CollectionDownloader"
    
    // It calls once
    public weak var delegate: CollectionListener?
    
    private var mDirPath: String
    private var mRootName: String
    
    private var mScreen: CGSize
    
    private var mChild: String
    
    private var mStorage: StorageReference
    
    private var mCacheCollections: [Collection] = []
    private var mNetCollections: [Collection] = []
    
    init(
        dir: String,
        child: String
    ) {
        
        mChild = child
        mStorage = Storage
            .storage()
            .reference(
                withPath: mChild
            )
        
        mRootName = dir
        
        mScreen = UIScreen
            .main
            .bounds
            .size
        
        mDirPath = StorageApp.rootPath(
            append: StorageApp.mDirCollection
        )
        .append(mRootName)
        .pathh()
        
        print(TAG, mDirPath)
        
    }
    
    deinit {
        print(TAG, "deinit()")
    }
    
    public func start() {
        
        let timelist = mStorage
            .child("RU.st")
        
        timelist.getMetadata { [weak self]
            meta, error in
            
            guard let s = self else {
                print("CollectionDownloader: getMetadata: garbage collected")
                return
            }
            
            guard let meta = meta,
                  error == nil else {
                print(s.TAG, "ERROR: ", error)
                return
            }
            
            s.checkTime(
                meta
            )
            
        }
        
    }
    
    private func checkTime(
        _ meta: StorageMetadata
    ) {
        
        let listc = mStorage
            .child("RU")
        
        let time = StorageApp
            .modifTime(
                path: mDirPath
            )
        
        let netTime = meta
            .updated?
            .timeIntervalSince1970 ?? 0
        
        loadCache()
        
        print(TAG, "CURRENT:",
              netTime, "PREV:",
              time
        )
        
        if netTime <= time {
            delegate?.onFinish()
            return
        }
        
        StorageApp.mkdir(
            path: mDirPath
        )
        
        StorageApp
            .modifTime(
                path: mDirPath,
                time: netTime
            )
        
        
        listc.listAll { [weak self]
            list, error in
            
            guard let s = self else {
                print("CollectionDownloader: listAll: ARC collected")
                return
            }
            
            guard let list = list,
                  error == nil else {
                print(s.TAG, "ERROR_LIST:",error)
                return
            }
            
            s.refreshData(list
                .items
            )
        }
    }
    
    private func refreshData(
        _ items: [StorageReference]
    ) {
        download(Iterator(items)) {
            [weak self] in
            
            guard let s = self else {
                print("CollectionDownloader: download: self is garbage collected")
                return
            }
            
            if s.delegate == nil {
                return
            }
            
            if s.mCacheCollections
                .isEmpty {
                s.delegate!
                    .onFirstCollection(
                        c: &s
                        .mNetCollections
                    )
                s.delegate!
                    .onFinish()
                return
            }
            
            let a = s.mCacheCollections.count
            let b = s.mNetCollections.count
            
            var i = b
            while i < a {
                s.delegate!.onRemove(i: i)
                i += 1
            }
            
            i = a
            
            while i < b {
                s.delegate!.onAdd(i: i)
                i += 1
            }
            
            for i in s
                .mCacheCollections
                .indices {
                s.mCacheCollections[i] = s.mNetCollections[i]
                
                s.delegate!.onUpdate(i:i)
            }
            
            s.delegate!
                .onFinish()
        }
    }
    
    private func download(
        _ items: Iterator<StorageReference>,
        completion: (()->Void)?
    ) {
        
        let a = items.next()
        
        if a == nil {
            completion?()
            return
        }
        
        a!.getData(
            maxSize: 1024*1024
        ) { [weak self] data, error in
            
            guard let s = self else {
                print("CollectionDownloader: getData:", items.index(), " self is garbage collected")
                return
            }
            
            guard let data = data,
                  error == nil else {
                print(s.TAG, "ERROR_COL:",error)
                return
            }
            
            s.addCollection(
                Utils.Exten.getSCSFile(
                    data
                ),
                &s.mNetCollections
            )
            
            StorageApp.collection(
                s.mRootName,
                id: items.index(),
                data: data
            )
            
            s.download(
                items,
                completion: completion
            )
        }
        
    }
    
    private func loadCache() {
        print(TAG, "loadCache:",mDirPath)
        if !StorageApp.exists(
            at: mDirPath
        ) {
            print(TAG, "loadCache: not exists")
            return
        }
        
        StorageApp.urlContent(
            at: mDirPath
        ) { fileName in
            guard let d = StorageApp.collection(
                mRootName,
                fileName: fileName
            ) else {
                print(TAG, "loadCache: data_nil:",fileName)
                return
            }
            addCollection(
                d,
                &mCacheCollections
            )
            
        }
        
        delegate?.onFirstCollection(
            c: &mCacheCollections
        )
        
    }
    
    private func addCollection(
        _ col: FileSCS?,
        _ c: inout [Collection]
    ) {
        guard let col = col else {
            return
        }
        
        let titleSize = mScreen.width * 0.067
        
        let mCardSizeB = MainViewController
            .mCardSizeB!
        
        let cs = mCardSizeB.height
        
        let height = cs + titleSize + cs * 0.193 + cs * 0.124
        
        print(TAG, "addCollection:",col.title, col.topics)
        
        c.append(
            CollectionTopic(
                topicsIDs: col.topics ?? [],
                titleSize: titleSize,
                cardSize: mCardSizeB,
                title: col.title ?? "",
                height: height
            )
        )
    }
    
    
}

extension URL {
    
    func append(
        _ s: String
    ) -> URL {
        
        if #available(iOS 16.0, *) {
            return appending(
                path: s
            )
        }
        
        return appendingPathComponent(
            s
        )
    }
    
    func pathh() -> String {
        if #available(iOS 16.0, *) {
            return path()
        }
        
        return path
    }
    
}
