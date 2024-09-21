//
//  SKServiceServerTime.swift
//  SPOK
//
//  Created by GoodDamn on 20/09/2024.
//

import Foundation
import FirebaseDatabase

final class SKServiceServerTime {
    
    weak var onGetServerTime: SKListenerOnGetServerTime? = nil
    
    private let mReference = Database
        .database()
        .reference(
            withPath: "opt/time"
        )
    
    func getServerTimeAsync() {
        mReference.observeSingleEvent(
            of: .value
        ) { [weak self] snap in
            
            guard let timeSec = snap.value as? Int else {
                return
            }
            
            self?.onGetServerTime?.onGetServerTime(
                timeSec: timeSec
            )
        }
    }
    
}
