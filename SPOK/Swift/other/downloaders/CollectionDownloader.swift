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
    
    private var mCacheCollections: ArrayList<Collection> = ArrayList()
    
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
            
            if s.mCacheCollections.a
                .isEmpty {
                
                s.mCacheCollections.a = s.mNetCollections
                
                s.delegate!
                    .onFirstCollection(
                        c: &s.mCacheCollections
                    )
                
                s.delegate!
                    .onFinish()
                return
            }
            
            let a = s.mCacheCollections.a.count
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
            
            for i in s.mCacheCollections
                .a
                .indices {
                
                s.mCacheCollections.a[i] = s.mNetCollections[i]
                
                s.delegate!.onUpdate(
                    i: i
                )
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
            
            var d: FileSCS? = Utils.Exten.getSCSFile(
                data
            )
            
            s.addCollection(
                &d,
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
            var d = StorageApp
                .collection(
                    mRootName,
                    fileName: fileName
                )
            
            addCollection(
                &d,
                &mCacheCollections.a
            )
            
        }
        
        delegate?.onFirstCollection(
            c: &mCacheCollections
        )
        
    }
    
    private func addCollection(
        _ col: inout FileSCS?,
        _ c: inout [Collection]
    ) {
        guard var col = col else {
            print(TAG, "data_nil: col: addCollection:")
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
                topicsIDs: &col.topics!,
                titleSize: titleSize,
                cardSize: mCardSizeB,
                title: col.title ?? "",
                height: height,
                cardTextSize: MainViewController.mCardTextSizeB,
                cardType: .B
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
