//
//  ScriptReader.swift
//  SPOK
//
//  Created by GoodDamn on 04/01/2024.
//

import Foundation

class ScriptReader {
    
    weak var onReadScript: OnReadScript? = nil
    
    private final var mEngine: SPOKContentEngine
    
    private final var mFileLen: Int
    private final var mChunkLen: Int
    private final var mStream: FileInputStream
    
    init(
        engine: SPOKContentEngine,
        dataSKC: inout Data
    ) {
        mEngine = engine
        
        mStream = FileInputStream(
            data: &dataSKC
        )
        // deny resource length
        let resLenByte = mStream.read(4)

        mFileLen = dataSKC.count
        mChunkLen = mFileLen - resLenByte.int32()
        
        Log.d(
            ScriptReader.self,
            "FILE_LEN:",
            mFileLen,
            "CHUNK_LEN:",
            mChunkLen
        )
    }
    
    func next() {
        
        if mStream.position() >= mChunkLen {
            Log.d(
                ScriptReader.self,
                "SCRIPT SECTION IS EMPTY"
            )
            onReadScript?.onFinish()
            return
        }
        
        let chunkLenBytes = mStream.read(4)
        
        let chunkLen = chunkLenBytes.int32()
        
        Log.d(
            ScriptReader.self,
            "CHUNK_LEN:",
            chunkLen,
            "BYTES:",
            chunkLenBytes
        )
        var chunkBytes = mStream
            .read(chunkLen+2)
        
        mEngine.read(
            chunk: &chunkBytes
        )
        
    }
    
    func progress() -> CGFloat {
        return CGFloat(mStream.position()) / CGFloat(mChunkLen)
    }
    
}
