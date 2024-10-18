//
//  SKPlayerAudio.swift
//  SPOK
//
//  Created by GoodDamn on 11/10/2024.
//

import Foundation
import AVFoundation

final class SKPlayerAudio
: AVPlayer {
    
    weak var onTickPlayer: SKIListenerOnTickAudio? = nil
    private var mTimer: Timer? = nil
    
    private(set) var isPlaying = false
    
    override func play() {
        timer()
        super.play()
        isPlaying = true
    }
    
    override func pause() {
        mTimer?.invalidate()
        mTimer = nil
        super.pause()
        isPlaying = false
    }
    
    
    @objc private func onTickPlayerAudio() {
        onTickPlayer?.onTickAudio(
            player: self
        )
    }
}


extension SKPlayerAudio {
    
    func prepareSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback)
        try session.setActive(true)
    }
    
}

extension SKPlayerAudio {
    
    private func timer() {
        mTimer?.invalidate()
        mTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(
                onTickPlayerAudio
            ),
            userInfo: nil,
            repeats: true
        )
    }
    
}
