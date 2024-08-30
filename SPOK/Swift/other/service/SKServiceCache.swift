//
//  SKServiceCache.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation

final class SKServiceCache {
    
    private var mFile: SKFile
    
    init (
        fileName: String = "",
        dirName: String
    ) {
        
        let dir = SKFile(
            dir: dirName
        )
        
        dir.mkdirs()
        
        mFile = SKFile(
            dir: dirName,
            name: fileName
        )
        
        mFile.createNewFile()
    }
    
    final func isEmpty() -> Bool {
        return (
            !mFile.exists() &&
            mFile.length() == 0
        )
    }
    
    final func isValidCache(
        time: Int
    ) -> Bool {
        return (
            mFile.exists() &&
            mFile.length() != 0 &&
            mFile.lastModified() >= time
        )
    }
    
    final func setLastModified(
        time: Int
    ) {
        mFile.setLastModified(
            time: time
        )
    }
    
    final func getData() -> Data? {
        return mFile.data()
    }
    
    final func writeData(
        data: inout Data
    ) {
        mFile.createNewFile(
            data: &data
        )
    }
    
}
