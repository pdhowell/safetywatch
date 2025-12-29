//
//  SOSMapGradients.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 29.12.2025.
//

import SwiftUI

enum SOSMapGradients {
    static let pinCore = LinearGradient(
        colors: [
            SOSMapColors.pinCoreTop,
            SOSMapColors.pinCoreBottom
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
