//
//  OnReadCommand.swift
//  SPOK
//
//  Created by GoodDamn on 04/01/2024.
//

import Foundation
import AVFoundation

public protocol OnReadCommand {
    func onAmbient(
        _ player: AVAudioPlayer?
    )
    
    func onSFX(
        _ sfxId: Int?,
        _ soundPool: [AVAudioPlayer?]
    )
    
    func onError(
        _ errorMsg: String
    )
}
