//
//  AVAsset.swift
//  SPOK
//
//  Created by GoodDamn on 12/02/2024.
//

import Foundation
import AVKit

extension AVAsset {
    
    static func asset(
        from data: inout Data,
        exten: String
    ) -> (AVAsset, URL) {
        
        let tempUrl = FileManager
            .temp(
                data: &data,
                exten: exten
            )
        
        let asset = AVAsset(
            url: tempUrl
        )
        
        return (asset, tempUrl)
        
    }
    
    
    static func mp3Meta(
        from data: inout Data
    ) -> Metadata? {
        
        let (asset, url) = asset(
            from: &data,
            exten: ".mp3"
        )
        
        print("AVAsset:", FileManager.default.fileExists(
            atPath: url.pathh()
        ))
        
        let meta = asset.metadata
        
        let title = meta.first(
            where: {
                $0.commonKey == .commonKeyTitle
            }
        )?.value as? String
        
        let artist = meta.first {
            $0.commonKey == .commonKeyArtist
        }?.value as? String
        
        print("AVAsset:", artist, title)
        
        FileManager
            .delete(
                url: url
            )
        
        if artist == nil {
            return nil
        }
        
        return Metadata(
            title: title,
            artist: artist
        )
    }
    
}
