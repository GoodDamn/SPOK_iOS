
import AVFoundation
import SPOK

public class SPOKContentEngine {
    
    private let TAG = "SPOKContentEngine:"
    
    private final let READ_BACKGROUND = 2;
    private final let READ_IMAGE = 3;
    private final let READ_GIF = 4;
    private final let READ_SFX = 5;
    private final let READ_AMBIENT = 6;
    private final let READ_VECTOR = 7;
    
    private var mSfxPool:[AVAudioPlayer] = []
    private var mResources: [NSObject] = []
    
    
    func read(
        chunk: [Int8]
    ) {
        
        var offset = 0
        
        print(TAG, "CHUNK: " ,chunk);
        print(TAG, "CHUNL_LEN:",chunk[offset])
        
        
        var textLen = ByteUtils
            .short(
                data: chunk,
                off: offset
            )
        
        offset += 2
        
        let textBytes = chunk[offset..<textLen]
        
        let text = String(
            bytes: textBytes,
            encoding: .utf8
        )
        
        var textConfig = ScriptTextConfig()
        
        var advancedText = text.components(
            separatedBy: "|"
        )
        
        if (advancedText.count != 1) {
            textConfig.mAdvancedText = advancedText
        }
        
        textConfig.spannableString = advancedText[0]
        
        var i = textLen
        
        if (chunk.count == i + offset) {
            return
        }
        
        let scriptSize = UInt8(chunk[i+offset] & 0xff)
        
        print(TAG, "SCRIPT_SIZE:", scriptSize)
        
        var j = 0
        
        while (j < scriptSize) {
            
            var sResFile:ScriptResourceFile?
            = nil
            
            var currentOffset = i+j+offset
            var argSize = chunk[currentOffset] & 0xff
            currentOffset += 1
            
            let commandIndex = chunk[currentOffset]
            
            switch (commandIndex) {
            case 0: // textSize
                ScriptRead.textSize(
                    chunk: chunk,
                    offset: currentOffset,
                    argSize: argSize,
                    textConfig: textConfig)
                break
            case 1: // font
                ScriptRead.font(
                    chunk: chunk,
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
                    chunk: chunk,
                    offset: currentOffset)
                break
            case READ_AMBIENT:
                sResFile = ScriptRead.ambient(
                    chunk: chunk,
                    offset: currentOffset)
                break
            case READ_VECTOR:
                break
            default:
                break
            }
            j += argSize
        }
    }
    
    
    func loadResources(
        dataSKC: Data
    ) {
        
        let data = ([Int8])(dataSKC)
        
        let resLen = ByteUtils
            .int(
                data,
                0
            )
        
        let resPos = dataSKC.count - resLen - 4
        
        let resCount = data[resPos+1]
        
        mResources = [NSObject?](
            repeating: nil,
            count: resCount
        )
        
        var prevPos = 0
        var currentPos: Int
        var fileLen: Int
        
        var fileSectionPos = resCount * 4
        
        var sfxID = 1
        var file:[Int8]
        
        for i in 0..<resCount {
            
        }
        
    }
    
}
