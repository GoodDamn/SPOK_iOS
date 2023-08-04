//
//  Networking.swift
//  SPOK
//
//  Created by Cell on 16.03.2022.
//

import Network

final class Networking{
    static let shared = Networking();
    
    private let queue = DispatchQueue.global();
    private let monitor: NWPathMonitor;
    
    public private(set) var isConnected: Bool = false;
    
    private init(){
        monitor = NWPathMonitor();
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue);
        setUpdateHadler({ [weak self] path in
            self?.isConnected = path.status == .satisfied;
        });
    }
    
    public func setUpdateHadler(_ handler: ((NWPath)->Void)?){
        monitor.pathUpdateHandler = handler;
    }
    
    public func interrupt(){
        monitor.cancel();
    }
}
