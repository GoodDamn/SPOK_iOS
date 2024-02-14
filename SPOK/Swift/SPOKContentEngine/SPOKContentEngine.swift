
import AVFoundation

public final class SPOKContentEngine {
    
    private let TAG = "SPOKContentEngine:"
    
    private final let READ_BACKGROUND = 2;
    private final let READ_IMAGE = 3;
    private final let READ_GIF = 4;
    private final let READ_SFX = 5;
    private final let READ_AMBIENT = 6;
    private final let READ_VECTOR = 7;
    
    private var mOnEndScript:((ScriptText) -> Void)? = nil
    
    private var mOnReadCommand: OnReadCommand? = nil
    
    private var mSfxPool:[AVAudioPlayer?] = []
    private var mResources: [Any?] = []
    
    private var metadata: Metadata? = nil
    
    public init() {}
    
    public final func read(
        chunk: inout Data
    ) {
        
        var offset = Int(chunk.startIndex)
        
        print(TAG, "LEN:",chunk[offset])
        
        let textLen = ByteUtils
            .short(
                &chunk
            )
        
        offset += 2
        
        let textBytes = chunk[
            offset..<(textLen+offset)
        ]
        
        let text = String(
            bytes: textBytes,
            encoding: .utf8
        ) ?? ""
        
        let textConfig = ScriptText()
        
        let advancedText = text.components(
            separatedBy: "|"
        )
        
        print(TAG, "TEXT:", text)
        
        if (advancedText.count != 1) {
            textConfig.mAdvancedText = advancedText
        }
        
        textConfig.spannableString = advancedText[0]
        
        var i = textLen
        
        print(
            TAG,
            "EXPRESSION:",
            chunk.count,
            i,
            offset
        )
        
        if chunk.count == (i + offset) {
            return
        }
        
        let scriptSize = UInt8(chunk[i+offset])
        
        i += 1
        
        print(TAG, "SCRIPT_SIZE:", scriptSize)
        
        var j = 0
        
        while (j < scriptSize) {
            
            var sResFile
            : ScriptResource?
            = nil
            
            var currentOffset = i+j+offset
            let argSize = Int(
                UInt8(
                    chunk[currentOffset]
                )
            )
            currentOffset += 1
            
            let commandIndex = Int(chunk[currentOffset])
            
            print(
                TAG,
                "LOOP:",
                currentOffset,
                commandIndex,
                argSize
            )
            
            switch (commandIndex) {
            case 0: // textSize
                ScriptRead.textSize(
                    chunk: &chunk,
                    offset: currentOffset,
                    argSize: argSize,
                    textConfig: textConfig)
                break
            case 1: // font
                ScriptRead.font(
                    chunk: &chunk,
                    offset: currentOffset,
                    argSize: argSize,
                    textConfig: textConfig)
                break
            case READ_BACKGROUND:
                break
            case READ_IMAGE:
                break
            case READ_BACKGROUND:
                break
            case READ_SFX:
                sResFile = ScriptRead.sfx(
                    chunk: &chunk,
                    offset: currentOffset)
                mOnReadCommand?.onSFX(
                    mResources[
                        Int(sResFile!
                            .resID)
                    ] as? Int,
                    mSfxPool
                )
                break
            case READ_AMBIENT:
                sResFile = ScriptRead.ambient(
                    chunk: &chunk,
                    offset: currentOffset)
                print(TAG, "READ_AMBIENT:",
                      sResFile!.resID,
                      mResources.count
                )
                mOnReadCommand?.onAmbient(
                    mResources[
                        Int(sResFile!
                            .resID)
                    ] as? AVAudioPlayer
                )
                break
            case READ_VECTOR:
                break
            default:
                mOnReadCommand?.onError(
                    "Invalid command index: \(commandIndex)"
                )
                break
            }
            j += argSize
        }
        mOnEndScript?(textConfig)
    }
    
    
    public final func loadResources(
        dataSKC: inout Data
    ) {
        
        let fis = FileInputStream(
            data: &dataSKC
        )
        
        let fileSize = dataSKC.count
        
        print(TAG, "FileSize:",fileSize)
        
        var resLenBytes = fis.read(4)
        
        print(TAG,"RES_LEN_BYTES:",([UInt8])(resLenBytes))
        
        let resLen = ByteUtils
            .int(
                &resLenBytes
            )
        
        print(TAG, "RES_LEN:",resLen)
        
        let resPos = fileSize - resLen - 4
        
        print(TAG, "RES_POS:",resPos)
        
        fis.skip(resPos-1)
        
        let resCount = Int(
            fis.read()
        )

        fis.skip(1)
        
        print(TAG, "RES_COUNT:",resCount)
        
        mResources = [Any?](
            repeating: nil,
            count: resCount
        )
        
        var prevPos = 0
        var currentPos: Int
        var fileLen: Int
        
        let fileSectionPos = resCount * 4
        
        var sfxID = 0
        var file: Data
        
        for i in 0..<resCount {
            
            // end file pos
            var endPosByte =
                fis.read(4)
            
            currentPos = ByteUtils
                .int(&endPosByte)
            
            print(TAG, "RES_END_POS:",currentPos, ([UInt8])(endPosByte))
            
            fileLen = currentPos - prevPos
            print(TAG, "FILE_LEN:",fileLen)
            
            let ret = fileSectionPos - (i + 1) * 4 + prevPos
            
            fis.skip(ret-1)
            
            // Read file content
            // Read header file
            let h = Int(fis.read())
            fis.skip(-1)
            file = fis.read(1,fileLen)
            
            print(
                TAG,
                "HEADER:",h,
                "FILE_SIZE:", file.count
            )
            
            if (h == 71) {
                // GIF
            } else if ((h & 0xff) == 137) {
                // PNG
            } else if (h == 73) {
                // MP3
                guard let player = try?
                    AVAudioPlayer(
                        data: file,
                        fileTypeHint: AVFileType
                            .mp3
                            .rawValue
                    ) else {
                    print(TAG, "ERROR: AVAudioPlayer")
                    continue
                }
                player.prepareToPlay()
                
                // 1 MB
                if file.count <= 1048579 {
                    mResources[i] = sfxID
                    mSfxPool.append(
                        player
                    )
                    sfxID += 1
                } else {
                    mResources[i] = player
                    player.numberOfLoops = -1
                    player.setVolume(
                        0.0,
                        fadeDuration: 0
                    )
                    
                    metadata = AVAsset
                        .mp3Meta(
                            from: &file
                        )
                    
                }
            } else {
                // .svc
            }
            
            prevPos = currentPos
            fis.skip(-fileLen-ret)
        }
        
        fis.close()
    }

    public final func metadataAmbient(
    ) -> Metadata? {
        return metadata
    }
    
    public final func release() {
        mResources.removeAll()
        mSfxPool.removeAll()
    }
    
    public final func setOnEndScriptListener(
        _ l: ((ScriptText) -> Void)?
    ) {
        mOnEndScript = l
    }
    
    public final func setOnReadCommandListener(
        _ l: OnReadCommand?
    ) {
        mOnReadCommand = l
    }
    
}
