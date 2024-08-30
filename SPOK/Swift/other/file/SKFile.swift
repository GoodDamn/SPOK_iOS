//
//  File.swift
//  SPOK
//
//  Created by GoodDamn on 29/08/2024.
//

import Foundation

final class SKFile {
    
    private let manager = FileManager
        .default
    
    private var mCurrentUrl: URL
    
    init(
        dir: String,
        name: String = ""
    ) {
        mCurrentUrl = manager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0].append(
            dir
        ).append(
            name
        )
    }
    
    final func mkdir() {
        if exists() {
            return
        }
        
        try? manager.createDirectory(
            at: mCurrentUrl,
            withIntermediateDirectories: false
        )
    }
    
    final func mkdirs() {
        if exists() {
            return
        }
        
        try? manager.createDirectory(
            at: mCurrentUrl,
            withIntermediateDirectories: true
        )
    }
    
    final func length() -> UInt64 {
        guard let attr = try? manager.attributesOfItem(
            atPath: mCurrentUrl.pathh()
        ) else {
            return 0
        }
        
        return attr[
            FileAttributeKey.size
        ] as? UInt64 ?? 0
    }
    
    final func createNewFile() {
        if exists() {
            return
        }
        
        manager.createFile(
            atPath: mCurrentUrl.pathh(),
            contents: nil
        )
    }
    
    final func createNewFile(
        data: inout Data
    ) {
        manager.createFile(
            atPath: mCurrentUrl.pathh(),
            contents: data
        )
    }
    
    final func data() -> Data? {
        return manager.contents(
            atPath: mCurrentUrl.pathh()
        )
    }
    
    final func lastModified() -> Int {
        guard let date = try? manager.attributesOfItem(
            atPath: mCurrentUrl.pathh()
        ) [FileAttributeKey.creationDate] as? Date else {
            return 0
        }
        return Int(
            date.timeIntervalSince1970
        )
    }
    
    final func setLastModified(
        time: Int
    ) {
        try? manager.setAttributes(
            [FileAttributeKey
                .creationDate: Date(
                    timeIntervalSince1970: Double(
                        time
                    )
                )
            ],
            ofItemAtPath: mCurrentUrl
                .pathh()
        )
    }
    
    final func exists() -> Bool {
        return manager.fileExists(
            atPath: mCurrentUrl.pathh()
        )
    }
    
}
