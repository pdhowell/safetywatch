//
//  SOSPhoneConnectivityProtocol.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation

protocol SOSPhoneConnectivityProtocol: AnyObject {
    var onStartSOS: (() -> Void)? { get set }
    func start()
    func sendStatusToWatch(status: String)
}
