//
//  SKServiceAppleProtect.swift
//  SPOK
//
//  Created by GoodDamn on 29/05/2024.
//

import Foundation
import FirebaseDatabase

final class SKServiceAppleProtect {
    
    private let mCurrentTime = Date()
        .timeIntervalSince1970
    
    private let mReference = Database.pirate()
    
    var onGetPiratedState: SKListenerOnGetPiratedState? = nil
    
    var isTimeForUpdateState: Bool {
        get {
            let time = UserDefaults
                .timeForAppleCheck()
            
            return mCurrentTime - time > .days7Sec()
        }
    }
    
    func getPiratedStateAsync() {
        if !isTimeForUpdateState {
            let appleChecks = UserDefaults
                .doAppleCheck()
            
            onGetPiratedState?.onGetPiratedState(
                isPirated: appleChecks
            )
            
            return
        }
        
        mReference.observeSingleEvent(
            of: .value
        ) { [weak self] snapshot in
            let isPirated = snapshot
                .exists()
            
            let def = UserDefaults.main()
            
            def.setValue(
                isPirated,
                forKey: Keys
                    .USER_DEF_APPLE_CHECK
            )
                        
            def.setValue(
                self?.mCurrentTime,
                forKey: Keys
                    .USER_DEF_APPLE_PREV_TIME
            )
            
            self?.onGetPiratedState?.onGetPiratedState(
                isPirated: isPirated
            )
            
        }
        
    }
}
