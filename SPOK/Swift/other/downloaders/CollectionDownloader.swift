//
//  CollectionDownloader.swift
//  SPOK
//
//  Created by GoodDamn on 13/01/2024.
//

import Foundation
import FirebaseStorage
import UIKit

class CollectionDowloader
    : Cache<Void> {
    
    private final let TAG = "CollectionDownloader"
    
    // It calls once
    public weak var delegateCollection: CollectionListener?
    
    private var mRootName: String
    
    private let mScreen: CGSize
    
    private var mCacheCollections: ArrayList<Collection> = ArrayList()
    
    private var mNetCollections: [Collection] = []
    
    init(
        dir: String,
        child: String
    ) {
        mRootName = dir
        
        let urlp = StorageApp.rootPath(
            append: StorageApp.mDirCollection
        ).append(mRootName)
        
        
        mScreen = UIScreen
            .main
            .bounds
            .size
        
        super.init(
            pathStorage: child,
            localPath: urlp,
            isDirectory: true
        )
        
    }
    
    deinit {
        print(TAG, "deinit()")
    }
    
    override func onUpdateCache() {
        mReference
            .child("RU")
            .listAll { [weak self]
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
    
    override func onCacheNotExpired() {
        delegateCollection?
            .onFinish()
    }
    
    public func start() {
        loadCache()
        checkMeta(
            childRef: "RU.st"
        )
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
            
            if s.delegateCollection == nil {
                return
            }
            
            if s.mCacheCollections.a
                .isEmpty {
                
                s.mCacheCollections.a = s.mNetCollections
                
                s.delegateCollection!
                    .onFirstCollection(
                        c: &s.mCacheCollections
                    )
                
                s.delegateCollection!
                    .onFinish()
                return
            }
            
            let a = s.mCacheCollections.a.count
            let b = s.mNetCollections.count
            
            var i = b
            while i < a {
                
                StorageApp
                    .deleteCollection(
                        s.mRootName,
                        id: i
                    )
                
                s.mCacheCollections
                    .a
                    .remove(
                        at: i
                    )
                s.delegateCollection!.onRemove(
                    i: i
                )
                i += 1
            }
            
            i = a
            
            while i < b {
                s.mCacheCollections
                    .a
                    .append(
                        s.mNetCollections[i]
                    )
                s.delegateCollection!
                    .onAdd(
                        i: i
                    )
                i += 1
            }
            
            for i in s.mCacheCollections
                .a
                .indices {
                
                s.mCacheCollections.a[i] = s.mNetCollections[i]
                
                s.delegateCollection!
                    .onUpdate(
                        i: i
                    )
            }
            
            s.delegateCollection!
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
            
            if data == nil || error != nil {
                print(s.TAG, "ERROR:DATA:",error)
                return
            }
            
            var data = data
            
            var d: FileSCS? = Utils
                .Exten
                .getSCSFile(
                    &data
                )
            
            s.addCollection(
                &d,
                &s.mNetCollections
            )
            
            StorageApp.collection(
                s.mRootName,
                id: items.index(),
                data: &data
            )
            
            s.download(
                items,
                completion: completion
            )
        }
        
    }
    
    private func loadCache() {
        print(TAG,
              "loadCache:",
              mPathToSave
        )
        
        if !StorageApp.exists(
            at: mPathToSave
        ) {
            print(TAG, "loadCache: not exists")
            return
        }
        
        StorageApp.urlContent(
            at: mPathToSave
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
        
        delegateCollection?.onFirstCollection(
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
        
        let cs = col.cardSize.height
        
        let height = cs + titleSize + cs * 0.193 + cs * 0.124
        
        print(TAG, "addCollection:",col.title, col.topics)
        
        c.append(
            CollectionTopic(
                topicsIDs: &col.topics!,
                titleSize: titleSize,
                cardSize: col.cardSize,
                title: col.title ?? "",
                height: height,
                cardTextSize: col.cardTextSize,
                cardType: col.type
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
