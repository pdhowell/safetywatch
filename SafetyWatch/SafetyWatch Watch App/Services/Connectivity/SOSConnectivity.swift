//
//  SOSConnectivity.swift
//  SafetyWatch Watch App Watch App
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation
import WatchConnectivity

final class SOSConnectivity: NSObject, WCSessionDelegate, SOSConnectivityProtocol {
    
    static let shared = SOSConnectivity()
    
    var onStatus: ((String) -> Void)?
    
    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func sendStartSOS() {
        guard WCSession.isSupported() else { return }
        
        let msg: [String: Any] = [
            "type": "start_sos",
            "ts": Date().timeIntervalSince1970
        ]
        
        WCSession.default.sendMessage(msg, replyHandler: nil) { _ in
            WCSession.default.transferUserInfo(msg)
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleIncoming(payload: message)
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        handleIncoming(payload: userInfo)
    }
    
    // MARK: - Private
    
    private func handleIncoming(payload: [String: Any]) {
        guard (payload["type"] as? String) == "sos_status" else { return }
        let status = (payload["status"] as? String) ?? "failed"
        onStatus?(status)
    }
}
