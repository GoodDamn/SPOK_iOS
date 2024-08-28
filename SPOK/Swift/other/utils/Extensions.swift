//
//  Extensions.swift
//  SPOK
//
//  Created by GoodDamn on 11/02/2024.
//

import Foundation
import UIKit.UIImage

public final class Extension {
    
    public static func spc(
        _ data: inout Data,
        scale: CGFloat = UIScreen.main.scale
    ) -> FileSPC {
        
        let conf = data[0];
        let isPremium = (conf & 0xff) >> 6 == 1;
        let categoryID = conf & 0x3f;
        
        let color = UIColor(
            red: CGFloat(data[2]) / 255,
            green: CGFloat(data[3]) / 255,
            blue: CGFloat(data[4]) / 255,
            alpha: CGFloat(data[1]) / 255
        );
        
        let descLen = Int(
            ByteUtils.short(
                &data,
                offset: 5
            )
        )
        
        var pos = 7 + descLen;
        let description = String(
            data: data[7..<pos],
            encoding: .utf8
        )
        
        let titleLen = Int(
            ByteUtils.short(
                &data,
                offset: pos
            )
        )
        
        pos += 2;
        let title = String(
            data: data[
                pos..<(titleLen+pos)
            ],
            encoding: .utf8
        );
        
        pos += titleLen;
        
        let image = UIImage(
            data: data[
                pos..<data.count
            ],
            scale: scale
        );
        
        return FileSPC(
            isPremium: isPremium,
            categoryID: categoryID,
            color: color,
            description: description,
            title: title,
            image: image
        );
    }
    
    public static func scs(
        _ data: inout Data,
        scale: CGFloat = UIScreen.main.scale,
        offset: Int = 0
    ) -> FileSCS? {
        var type: CardType
        var cardSize: CGSize
        var cardTextSize: CardTextSize
        
        switch(data[offset]) {
        case 0:
            cardSize = MainViewController
                .mCardSizeB
            type = .B
            cardTextSize = MainViewController
                .mCardTextSizeB
            break
        case 1:
            cardSize = MainViewController
                .mCardSizeM
            type = .M
            cardTextSize = MainViewController
                .mCardTextSizeM
            break
        default:
            type = .M
            cardTextSize = MainViewController
                .mCardTextSizeM
            cardSize = .zero
        }
        
        var pos = offset+1
        
        let titleLen = Int(data[pos])
        
        pos += 1
        
        let title = String(
            data: data[
                pos..<(titleLen+pos)
            ],
            encoding: .utf8
        )
        
        pos = titleLen+pos;
        
        let topicsLen = ByteUtils
            .int(
                &data,
                offset: pos
            )
        
        pos += 4
        var topics:[UInt16] = []
        let b = pos + topicsLen
        while pos < b {
            topics.append(
                UInt16(
                    ByteUtils.short(
                        &data,
                        offset: pos
                    )
                )
            )
            pos += 2;
        }
        
        return FileSCS(
            title: title,
            topics: topics,
            image: nil,
            cardSize: cardSize,
            cardTextSize: cardTextSize,
            type: type
        )
    }
}
