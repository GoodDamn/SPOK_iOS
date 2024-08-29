//
//  File.swift
//  SPOK
//
//  Created by GoodDamn on 29/08/2024.
//

import Foundation

final class File {
    
    private let manager = FileManager
        .default
    
    private var mCurrentUrl = manager.urls(
        for: .cachesDirectory,
        in: .userDomainMask
    )[0]
    
    init(
        dir: String,
        name: String = ""
    ) {
        mCurrentUrl = mCurrentUrl.append(
            dir
        ).append(
            name
        )
    }
    
    final func mkdir() {
        if exists() {
            return
        }
        
        manager.createDirectory(
            at: mCurrentUrl,
            withIntermediateDirectories: false
        )
    }
    
    final func mkdirs() {
        if exists() {
            return
        }
        
        manager.createDirectory(
            at: mCurrentUrl,
            withIntermediateDirectories: true
        )
    }
    
    final func createNewFile(
        data: Data? = nil
    ) {
        if exists() {
            return
        }
        
        manager.createFile(
            atPath: mCurrentUrl.pathh(),
            contents: data
        )
    }
    
    final func lastModified() -> Double {
        guard let date = try? manager.attributesOfItem(
            atPath: mCurrentUrl.pathh()
        ) [FileAttributeKey.creationDate] as? Date else {
            return 0
        }
        return date.timeIntervalSince1970
    }
    
    final func setLastModified(
        time: Double
    ) {
        try? manager.setAttributes(
            [FileAttributeKey
                .creationDate: Date(
                    timeIntervalSince1970: time
                )
            ],
            ofItemAtPath: mCurrentUrl
                .pathh()
        )
    }
    
    final func exists() -> Bool {
        return manager.fileExists(
            atPath: mCurrentUrl.pathh()
        ) || manager.fileExists(
            atPath: mCurrentUrl.pathh(),
            isDirectory: true
        )
    }
    
}
