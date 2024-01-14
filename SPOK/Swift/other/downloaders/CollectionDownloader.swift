//
//  CollectionDownloader.swift
//  SPOK
//
//  Created by GoodDamn on 13/01/2024.
//

import Foundation
import FirebaseStorage

class CollectionDowloader {
    
    private final let TAG = "CollectionDownloader"
    
    // It calls once
    public var delegate: CollectionListener? = nil
    
    private var mfm: FileManager
    private var mDirPath: String
    
    private var mChild: String
    
    private var mStorage: StorageReference
    
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
        
        mfm = FileManager.default
        
        let url = mfm.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0]
        
        mDirPath = url
            .append(dir)
            .pathh()
    }
    
    public func start() {
        
        let timelist = mStorage
            .child("RU.st")
        
        timelist.getMetadata {
            meta, error in
            
            guard let meta = meta,
                  error == nil else {
                print(self.TAG, "ERROR: ", error)
                return
            }
            
            self.checkTime(
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
        
        if time != 0 { // Folder not found
            loadCache()
        }
        
        print(TAG, "TIME:",
              currentTime,
              time
        )
        
        if currentTime < time {
            return
        }
        
        listc.listAll { list, error in
            
            guard let list = list,
                  error == nil else {
                print(self.TAG, "ERROR_LIST:",error)
                return
            }
            
            self.refreshData(list
                .items
            )
            
        }
    }
    
    private func refreshData(
        _ items: [StorageReference]
    ) {
        
    }
    
    private func download(
        _ item: StorageReference
    ) {
        item.getData(
            maxSize: 1024*1024
        ) { data, error in
            
            guard let data = data,
                  error == nil else {
                print(self.TAG, "ERROR_COL:",error)
                return
            }
            
        }
        
    }
    
    private func loadCache() {
        
        if !mfm.fileExists(
            atPath: mDirPath
        ) {
            return
        }
        
        let files = try? mfm
            .contentsOfDirectory(
                atPath: mDirPath
            )
        
        print(TAG, files)
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
