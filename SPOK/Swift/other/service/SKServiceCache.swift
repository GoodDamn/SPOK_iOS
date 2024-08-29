//
//  SKServiceCache.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation

final class SKServiceCache {
    
    private let mFileManager = FileManager
        .default
    
    private let mainUrl = mFileManager.urls(
        for: .cachesDirectory,
        in: .userDomainMask
    )[0]
    
    private var mPath = mainUrl
    
    private let mFileName: String
    private let mDirName: String
    
    init (
        fileName: String = "",
        dirName: String
    ) {
        mFileName = fileName
        mDirName = dirName
        
        mPath = mPath.append(
            mDirName
        )
    }
    
    func writeData(
        data: Data
    ) {
        mFileManager.createFile(
            atPath: mainUrl.append(
                mDirName
            ),
            contents: <#T##Data?#>
        )
    }
    
}
