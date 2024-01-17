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
    
    private var mScreen: CGSize
    
    private var mCardSizeB: CGSize
    private var mCardSizeM: CGSize
    
    private var mfm: FileManager
    private var mDirPath: String
    
    private var mChild: String
    
    private var mStorage: StorageReference
    
    private var mCacheCollections: [Collection] = []
    private var mNetCollections: [Collection] = []
    
    init(
        dir: String,
        child: String
    ) {
        
        mScreen = UIScreen
            .main
            .bounds
            .size
        
        mCardSizeB = CGSize(
            width: mScreen.width * 0.847,
            height: mScreen.width * 0.5
        )
        
        mCardSizeM = CGSize(
            width: mScreen.width * 0.4,
            height: mCardSizeB.height
        )
        
        mChild = child
        mStorage = Storage
            .storage()
            .reference(
                withPath: mChild
            )
        
        mfm = FileManager.default
        
        let url = mfm.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0]
        
        mDirPath = url
            .append(dir)
            .pathh()
        
        if mfm.fileExists(
            atPath: mDirPath
        ) {
            return
        }
        
        do {
            try mfm.createDirectory(
                atPath: mDirPath,
                withIntermediateDirectories: false
            )
        } catch {
            print(TAG, "ERROR_DIR:",error)
        }
        
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
        
        let time = getUpdateTime()
        let currentTime = meta
            .updated?
            .timeIntervalSince1970 ?? 0
        
        loadCache()
        
        print(TAG, "CURRENT:",
              currentTime, "PREV:",
              time
        )
        
        if currentTime <= time {
            delegate?.onFinish()
            return
        }
        
        let attr = [
            FileAttributeKey
                .creationDate: Date(
            timeIntervalSince1970: currentTime
                )
        ]
        do {
            try mfm.setAttributes(
                attr,
                ofItemAtPath: mDirPath
            )
        } catch {
            print(TAG, "ERROR:", error)
        }
        
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
        download(Iterator(items)) {[weak self] in
            
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
                data,
                &s.mNetCollections
            )
            
            s.writeScs(
                items.index(),
                data
            )
            
            s.download(
                items,
                completion: completion
            )
        }
        
    }
    
    private func loadCache() {
        if !mfm.fileExists(
            atPath: mDirPath
        ) {
            return
        }
        
        guard let fileUrls = try? mfm
            .contentsOfDirectory(
                atPath: mDirPath
            ) else {
            print(TAG, "NO_CONTENT_IN_DIR")
            return
        }
        
        for s in fileUrls {
            print(TAG, "FILE:",s)
            
            guard let d = mfm.contents(
                atPath: "\(mDirPath)/\(s)"
            ) else {
                print(TAG, "ERROR WITH",s)
                continue
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
        _ data: Data,
        _ c: inout [Collection]
    ) {
        let col = Utils.Exten
            .getSCSFile(data)
        
        let titleSize = mScreen.width * 0.067
        
        let height = mCardSizeB.height + titleSize
        
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
    
    private func writeScs(
        _ index: Int,
        _ data: Data
    ) {
        mfm.createFile(
            atPath: mDirPath+"/\(index).scs",
            contents: data
        )
    }
    
    private func getUpdateTime() -> Double {
        
        if mfm.fileExists(
            atPath: mDirPath
        ) {
            return StorageApp
                .modifTIme(
                    path: mDirPath, mfm
                )
        }
        
        return 0
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
