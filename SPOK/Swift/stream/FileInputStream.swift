//
//  FileInputStream.swift
//  SPOK
//
//  Created by GoodDamn on 04/01/2024.
//

import Foundation


public class FileInputStream {
    
    private final let TAG = "FileInputStream"
    
    private var mData: Data
    private var mIndex: Int
    
    init(
        data: inout Data
    ) {
       mData = data
       mIndex = 0
    }
    
    public func read(
    ) -> UInt8 {
        mIndex += 1
        print(TAG,
              "read: INDEX:",
              mIndex,
              "Indices:",
              mData.startIndex,
              mData.endIndex,
              "DATA_COUNT:",
              mData.count
        )
        return mData[mIndex]
    }
    
    public func read(
        _ n: Int
    ) -> Data {
        return read(0,n)
    }
    
    public func read(
        _ offset: Int,
        _ n: Int
    ) -> Data {
        mIndex += offset
        
        let start = mIndex
        let end = mIndex + n
        mIndex += n
        
        print(
            TAG,
            "BOUNDS:",
            start,
            end,
            mData.count
        )
        
        return mData[start..<end]
        
    }
    
    public func skip(
        _ n: Int
    ) {
        print(
            TAG,
            "skip:",
            n,
            "from:",
            mIndex
        )
        
        mIndex += n
    }
    
    public func position() -> Int {
        return mIndex
    }
    
    public func close() {
        mData.removeAll()
        mIndex = 0
    }
    
}
