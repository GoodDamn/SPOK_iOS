
import AVFoundation

public class SPOKContentEngine {
    
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
    
    public init() {}
    
    public func read(
        chunk: inout [UInt8]
    ) {
        
        var offset = 0
        
        print(TAG, "LEN:",chunk[offset])
        
        var textLen = ByteUtils
            .short(
                &chunk,
                offset
            )
        
        offset += 2
        
        let textBytes = chunk[offset..<(textLen+offset)]
        
        let text = String(
            bytes: textBytes,
            encoding: .utf8
        ) ?? ""
        
        var textConfig = ScriptText()
        
        var advancedText = text.components(
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
    
    
    public func loadResources(
        dataSKC: inout [UInt8]
    ) {
        
        let fis = FileInputStream(
            data: &dataSKC
        )
        
        let fileSize = dataSKC.count
        
        print(TAG, "FileSize:",fileSize)
        
        var resLenBytes = fis.read(4)
        
        print(TAG,"RES_LEN_BYTES:",resLenBytes)
        
        let resLen = ByteUtils
            .int(
                &resLenBytes
            )
        
        print(TAG, "RES_LEN:",resLen)
        
        let resPos = fileSize - resLen - 4
        
        print(TAG, "RES_POS:",resPos)
        
        fis.skip(resPos-1)
        
        let resCount = Int(UInt8(fis.read()))

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
        var file: [UInt8]
        
        for i in 0..<resCount {
            
            // end file pos
            var endPosByte =
                fis.read(4)
            
            currentPos = ByteUtils
                .int(&endPosByte)
            
            print(TAG, "RES_END_POS:",currentPos, endPosByte)
            
            fileLen = currentPos - prevPos
            print(TAG, "FILE_LEN:",fileLen)
            
            let ret = fileSectionPos - (i + 1) * 4 + prevPos
            
            fis.skip(ret-1)
            
            // Read file content
            // Read header file
            var h = Int(UInt8(fis.read()))
            fis.skip(-1)
            file = fis.read(fileLen)
            
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
                        data: Data(file),
                        fileTypeHint: AVFileType
                            .mp3
                            .rawValue
                    ) else {
                    print(TAG, "ERROR: AVAudioPlayer")
                    continue
                }
                player.prepareToPlay()
                
                // 1 MB
                if (file.count <= 1048579) {
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
                }
            } else {
                // .svc
            }
            
            prevPos = currentPos
            fis.skip(-fileLen-ret)
        }
        
        fis.close()
    }

    public func release() {
        mResources.removeAll()
        mSfxPool.removeAll()
    }
    
    public func setOnEndScriptListener(
        _ l: ((ScriptText) -> Void)?
    ) {
        mOnEndScript = l
    }
    
    public func setOnReadCommandListener(
        _ l: OnReadCommand?
    ) {
        mOnReadCommand = l
    }
    
}
