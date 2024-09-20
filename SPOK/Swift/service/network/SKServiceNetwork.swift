//
//  SKServiceNetwork.swift
//  SPOK
//
//  Created by GoodDamn on 19/09/2024.
//

import Foundation
import Network

final class SKServiceNetwork {
    
    weak var delegate: SKDelegateOnNetworkChanged? = nil
    
    private let monitor = NWPathMonitor()
    
    init() {
        monitor.pathUpdateHandler = {
            [weak self] path in
            self?.delegate?.onNetworkChanged(
                isConnected: path.status == .satisfied
            )
        }
        
    }
    
    func listenNetwork(
        queue: DispatchQueue
    ) {
        monitor.start(
            queue: queue
        )
    }
    
    
}
