//
//  SOSColors.swift
//  SafetyWatch Watch App Watch App
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import SwiftUI

enum SOSColors {
    
    static let backgroundBlack = Color.black
    
    static let redGlow = Color.red.opacity(0.35)
    
    static let ringBackground = Color.white.opacity(0.12)
    
    static let highlightStrong = Color.white.opacity(0.18)
    static let highlightWeak = Color.white.opacity(0.02)
    
    static let cancelFill = Color.white.opacity(0.10)
    static let cancelStrokeTop = Color.white.opacity(0.25)
    static let cancelStrokeBottom = Color.white.opacity(0.05)
    
    enum Primary {
        static let dark = Color(red: 0.42, green: 0.05, blue: 0.10)
        static let mid = Color(red: 0.78, green: 0.12, blue: 0.18)
        static let light = Color(red: 0.92, green: 0.32, blue: 0.22)
        
        static let ringStart = Color(red: 0.85, green: 0.14, blue: 0.18)
        static let ringMid1  = Color(red: 0.95, green: 0.32, blue: 0.20)
        static let ringMid2  = Color(red: 1.00, green: 0.55, blue: 0.28)
        static let ringAccent = Color(red: 0.90, green: 0.28, blue: 0.52)
        static let ringEnd   = Color(red: 0.85, green: 0.14, blue: 0.18)
    }
}
