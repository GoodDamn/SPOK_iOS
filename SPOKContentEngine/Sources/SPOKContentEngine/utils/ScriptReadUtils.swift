//
//  File.swift
//  
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation

class ScriptRead {
    
    
    public static func textSize(
        chunk: [Int8],
        offset: Int,
        argSize: Int,
        textConfig: ScriptTextConfig
    ) {
        let textSize = ByteUtils
            .short(
                data: chunk,
                off: offset+1
            ) / 1000
        
        offset += 3
        
        let s = nil
        
        if (argSize == 4) { // 1 args
            textConfig.textSize = textSize
            return
        }
    }
    
    public static func font(
        chunk: [Int8],
        offset: Int,
        argSize: Int,
        textConfig: ScriptTextConfig
    ) {
        let style = chunk[offset+1]
        
        var isColorSpan = false
        var color = 0
        
        offfset += 2
        
        switch (offset) {
        case 0: // underline
            break
        case 1: // strikethrough
            break
        case 2: // bold
            break
        case 3: // italic
            break
        case 4:
            let alpha = chunk[offset] & 0xff
            let red = chunk[offset+1] & 0xff
            let green = chunk[offset+2] & 0xff
            let blue = chunk[offset+3] & 0xff
            
            color = alpha << 24 |
                    red << 16 |
                    green << 8 |
                    blue
            
            offset += 4
            argSize -= 4
            
            isColorSpan = true
            break
        }
        
        
        var text = textConfig.spannableString
        
        if (argSize == 3) { // 2 args
            if (isColorSpan) {
                textConfig.textColor = color
            }
            
        }
        
        if (argSize == 5) { // 3 args
            
        }
        
        if (argSize == 7) { // 4 args
            
        }
        
        if (text != nil) {
            textConfig.spannableString = text
        }
        
    }
    
    public static func sfx(
        chunk: [Int8],
        offset: Int,
    ) -> ScriptResourceFile? {
        return resource(
            chunk,
            offset
        )
    }
    
    
    public static func ambient(
        chunk: [Int8],
        offset: Int,
    ) -> ScriptResourceFile? {
        return resource(
            chunk,
            offset
        )
    }
    
    
    private static func resource(
        _ chunk: [Int8],
        _ offset: Int,
    ) -> ScriptResourceFile? {
        offset += 1
        
        let resID = chunk[offset]
        
        if (resID <= -1) {
            return nil
        }
        
        return ScriptResourceFile(resID)
    }
    
}
