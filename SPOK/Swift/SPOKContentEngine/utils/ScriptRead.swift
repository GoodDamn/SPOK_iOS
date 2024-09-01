//
//  File.swift
//
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation

public class ScriptRead {
    
    public static func textSize(
        chunk: inout Data,
        offset: Int,
        argSize: Int,
        textConfig: ScriptText
    ) {
        var offset = offset
        let textSize = chunk.int16(
            offset: offset+1
        ) / 1000
        
        offset += 3
        
        if (argSize == 4) { // 1 args
            textConfig.textSize = Float(textSize)
            return
        }
    }
    
    public static func font(
        chunk: inout Data,
        offset: Int,
        argSize: Int,
        textConfig: ScriptText
    ) {
        var offset = offset
        var argSize = argSize
        let style = Int(chunk[offset+1])
        
        var isColorSpan = false
        var color = 0
        
        offset += 2
        
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
            
            color = Int(alpha << 24 |
                        red << 16 |
                        green << 8 |
                        blue)
            
            offset += 4
            argSize -= 4
            
            isColorSpan = true
            break
        default:
            break
        }
        
        
        let text = textConfig.spannableString
        
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
        chunk: inout Data,
        offset: Int
    ) -> ScriptResource? {
        return resource(
            &chunk,
            offset
        )
    }
    
    
    public static func ambient(
        chunk: inout Data,
        offset: Int
    ) -> ScriptResource? {
        return resource(
            &chunk,
            offset
        )
    }
    
    
    private static func resource(
        _ chunk: inout Data,
        _ offset: Int
    ) -> ScriptResource? {
        var offset = offset
        offset += 1
        
        let resID = Int8(chunk[offset])
        
        if (resID <= -1) {
            return nil
        }
        
        return ScriptResource(resID)
    }
    
}
