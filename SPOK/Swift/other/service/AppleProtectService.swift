//
//  PirateService.swift
//  SPOK
//
//  Created by GoodDamn on 29/05/2024.
//

import Foundation

final class AppleProtectService {
    
    private static let INTERVAL: TimeInterval = 604800
    
    private let mCurrentTime: TimeInterval
    
    init() {
        mCurrentTime = Date()
            .timeIntervalSince1970
    }
    
    deinit {
        Log.d(
            AppleProtectService.self,
            "deinit()"
        )
    }
    
    func isTimeForUpdateState() -> Bool {
        let time = UserDefaults.standard
            .timeForAppleCheck()
        
        return mCurrentTime - time > AppleProtectService.INTERVAL
    }
    
    func updateAppleState(
        completion: ((Bool) -> Void)? = nil
    ) {
        DatabaseUtils.pirate { [weak self]
            doAppleCheck in
            
            let def = UserDefaults
                .standard
            
            def.setValue(
                doAppleCheck,
                forKey: Keys
                    .USER_DEF_APPLE_CHECK
            )
                        
            def.setValue(
                self?.mCurrentTime,
                forKey: Keys
                    .USER_DEF_APPLE_PREV_TIME
            )
            
            completion?(doAppleCheck)
        }
    }
    
}
