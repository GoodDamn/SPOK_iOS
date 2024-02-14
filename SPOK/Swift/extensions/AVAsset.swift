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
        
        let meta = asset.metadata
        
        let title = asset.findMeta(
            .commonKeyTitle
        )
        
        let artist = asset.findMeta(
            .commonKeyArtist
        )
        
        FileManager
            .delete(
                url: url
            )
        
        return Metadata(
            title: title,
            artist: artist
        )
    }
    
    private func findMeta(
        _ key: AVMetadataKey
    ) -> String {
        metadata.first {
            $0.commonKey == key
        }?.value as? String ?? ""
    }
    
}
