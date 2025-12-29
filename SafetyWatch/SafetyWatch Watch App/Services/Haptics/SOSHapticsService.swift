//
//  SOSHapticsService.swift
//  SafetyWatch Watch App Watch App
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation
import WatchKit

final class SOSHapticsService: SOSHapticsServiceProtocol {
    func click() { WKInterfaceDevice.current().play(.click) }
    func success() { WKInterfaceDevice.current().play(.success) }
    func failure() { WKInterfaceDevice.current().play(.failure) }
    func notification() { WKInterfaceDevice.current().play(.notification) }
    func directionUp() { WKInterfaceDevice.current().play(.directionUp) }
}
