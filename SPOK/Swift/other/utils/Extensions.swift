//
//  Extensions.swift
//  SPOK
//
//  Created by GoodDamn on 11/02/2024.
//

import Foundation
import UIKit.UIImage

public final class Extension {
    
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
