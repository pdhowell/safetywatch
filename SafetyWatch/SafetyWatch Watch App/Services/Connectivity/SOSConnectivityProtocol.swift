//
//  SOSConnectivityProtocol.swift
//  SafetyWatch Watch App Watch App
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation

protocol SOSConnectivityProtocol: AnyObject {
    var onStatus: ((String) -> Void)? { get set }
    func sendStartSOS()
}
