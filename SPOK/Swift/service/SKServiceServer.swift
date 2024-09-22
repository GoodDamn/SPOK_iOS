//
//  SKServiceServer.swift
//  SPOK
//
//  Created by GoodDamn on 20/09/2024.
//

import Foundation
import FirebaseDatabase

final class SKServiceServer {
    
    weak var onGetServerConfig: SKListenerOnGetServerConfig? = nil
    
    private let mReference = Database
        .database()
        .reference(
            withPath: "opt"
        )
    
    func getServerConfigAsync() {
        mReference.observeSingleEvent(
            of: .value
        ) { [weak self] snap in
            
            let timeSec = snap.childSnapshot(
                forPath: "time"
            ).value as? Int ?? 0
            
            let vers = snap.childSnapshot(
                forPath: "versi"
            ).value as? Int ?? 0
            
            let state = (snap.childSnapshot(
                forPath: "state"
            ).value as? Int ?? 0) == 1
            
            self?.onGetServerConfig?.onGetServerConfig(
                model: SKModelServerConfig(
                    serverTimeSec: timeSec,
                    isGranted: state,
                    buildLastVersion: vers
                )
            )
        }
    }
    
}
