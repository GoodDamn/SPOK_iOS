//
//  Data.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
import UIKit

extension Data {
    
    mutating func spc() -> SKModelTopicPreview? {
        if isEmpty {
            return nil
        }
        
        let conf = self[0]
        let isPremium = (conf & 0xff) >> 6 == 1
        let categoryID = conf & 0x3f
        
        let color = UIColor(
            red: CGFloat(self[2]) / 255,
            green: CGFloat(self[3]) / 255,
            blue: CGFloat(self[4]) / 255,
            alpha: CGFloat(self[1]) / 255
        )
        
        let descLen = Int(
            ByteUtils.short(
                &self,
                offset: 5
            )
        )
        
        var pos = 7 + descLen
        let description = String(
            data: self[7..<pos],
            encoding: .utf8
        )
        
        let titleLen = Int(
            ByteUtils.short(
                &self,
                offset: pos
            )
        )
        
        pos += 2
        let title = String(
            data: self[
                pos..<(titleLen+pos)
            ],
            encoding: .utf8
        )
        
        pos += titleLen;
        
        let image = UIImage(
            data: self[
                pos..<count
            ],
            scale: 3.0 // UIScreen.main.scale
        )
        
        return SKModelTopicPreview(
            title: title,
            desc: description,
            isPremium: isPremium,
            preview: image
        )
    }
    
    mutating func scc() -> [SKModelCollection]? {
        if isEmpty {
            return nil
        }
        
        let n = Int(self[0])
        var collections = Array<SKModelCollection>()
        collections.reserveCapacity(n)
        
        var dd: FileSCS?
        var i = 1
        var lenCol: Int
        
        while (
            i < count
        ) {
            lenCol = ByteUtils.short(
                &self,
                offset: i
            )
            i += 2
            
            dd = Extension.scs(
                &self,
                offset: i
            )
            
            if let d = dd {
                if let t = d.topics {
                    collections.append(
                        SKModelCollection(
                            title: d.title,
                            topicIds: t
                        )
                    )
                }
            }
            
            i += lenCol
        }
        
        return collections
    }
    
}
