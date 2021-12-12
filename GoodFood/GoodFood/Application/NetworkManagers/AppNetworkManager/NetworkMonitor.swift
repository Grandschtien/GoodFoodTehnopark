//
//  NetworkMonitor.swift
//  GoodFood
//
//  Created by Егор Шкарин on 12.12.2021.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    
    private let monitor: NWPathMonitor
    
    public private(set) var isConnncted = false
    public private(set) var connectionType: ConnectionType = .unknown
    enum ConnectionType {
        case wifi
        case celluar
        case ethernet
        case unknown
    }
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {[weak self] path in
            self?.isConnncted = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .celluar
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else{
            connectionType = .unknown
        }
    }
}
