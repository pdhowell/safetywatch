//
//  SOSPhoneConnectivity.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation
import WatchConnectivity

final class SOSPhoneConnectivity: NSObject, WCSessionDelegate, SOSPhoneConnectivityProtocol {
    
    static let shared = SOSPhoneConnectivity()
    
    var onStartSOS: (() -> Void)?
    
    private override init() {
        super.init()
    }
    
    func start() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func sendStatusToWatch(status: String) {
        guard WCSession.isSupported() else { return }
        
        let msg: [String: Any] = [
            "type": "sos_status",
            "status": status
        ]
        
        WCSession.default.sendMessage(msg, replyHandler: nil) { _ in
            WCSession.default.transferUserInfo(msg)
        }
    }
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleIncoming(payload: message)
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        handleIncoming(payload: userInfo)
    }
    
    private func handleIncoming(payload: [String: Any]) {
        guard (payload["type"] as? String) == "start_sos" else { return }
        onStartSOS?()
    }
}
