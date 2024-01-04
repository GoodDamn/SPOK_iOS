//
//  ScriptReader.swift
//  SPOK
//
//  Created by GoodDamn on 04/01/2024.
//

import Foundation

public class ScriptReader {
    
    private final let TAG = "ScriptReader"
    private final var mEngine: SPOKContentEngine
    
    private final var mFileLen: Int
    private final var mChunkLen: Int
    private final var mStream: FileInputStream
    
    private var mOnReadScript: OnReadScript? = nil
    
    public init(
        engine: SPOKContentEngine,
        dataSKC: [UInt8]
    ) {
        mEngine = engine
        
        mStream = FileInputStream(
            data: dataSKC
        )
        // deny resource length
        let resLenByte = mStream.read(4)

        mFileLen = dataSKC.count
        mChunkLen = mFileLen - ByteUtils
            .int(resLenByte)
        
        print(
            TAG,
            "FILE_LEN:",
            mFileLen,
            "CHUNK_LEN:",
            mChunkLen
        )
    }
    
    public func next() {
        
        if mStream.position() >= mChunkLen {
            print(TAG, "SCRIPT SECTION IS EMPTY")
            mOnReadScript?.onFinish()
            return
        }
        
        let chunkLenBytes = mStream.read(4)
        
        let chunkLen = ByteUtils
            .int(chunkLenBytes)
        
        print(
            TAG,
            "CHUNK_LEN:",
            chunkLen,
            "BYTES:",
            chunkLenBytes
        )
        let chunkBytes = mStream
            .read(chunkLen+2)
        
        mEngine.read(
            chunk: chunkBytes
        )
        
    }
    
    public func setOnReadScriptListener(
        _ l: OnReadScript?
    ) {
        mOnReadScript = l
    }
    
}
