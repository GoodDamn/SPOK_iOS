//
//  PirateService.swift
//  SPOK
//
//  Created by GoodDamn on 29/05/2024.
//

import Foundation

final class AppleProtectService {
    
    private static let INTERVAL: TimeInterval = 604800
    
    func isTimeForUpdateState() -> Bool {
        let time = UserDefaults.standard
            .timeForAppleCheck()
        
        let currentTime = Date().timeIntervalSince1970
        
        return currentTime - time > AppleProtectService.INTERVAL
    }
    
    func updateAppleState() {
        DatabaseUtils.pirate {
            doAppleCheck in
            
            let def = UserDefaults
                .standard
            
            def.setValue(
                doAppleCheck,
                forKey: Keys.USER_DEF_APPLE_CHECK
            )
        }
    }
    
}
