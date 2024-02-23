//
//  AVAudioPlayer.swift
//  SPOK
//
//  Created by GoodDamn on 15/02/2024.
//

import Foundation
import AVFoundation

extension AVAudioPlayer {
    
    func stopFade(
        duration f: TimeInterval = 1.5,
        completion: (()->Void)? = nil
    ) {
        setVolume(
            0.0,
            fadeDuration: f
        )
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + f
        ) { [weak self] in
            self?.stop()
            completion?()
        }
    }
    
}
