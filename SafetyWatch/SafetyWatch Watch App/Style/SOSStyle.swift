//
//  SOSStyle.swift
//  SafetyWatch Watch App Watch App
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import SwiftUI

enum SOSStyle {
    
    enum Gradients {
        
        static let fill = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: SOSColors.Primary.dark, location: 0.00),
                .init(color: SOSColors.Primary.mid, location: 0.45),
                .init(color: SOSColors.Primary.light, location: 1.00)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let primaryRing = AngularGradient(
            gradient: Gradient(stops: [
                .init(color: SOSColors.Primary.ringStart, location: 0.00),
                .init(color: SOSColors.Primary.ringMid1, location: 0.22),
                .init(color: SOSColors.Primary.ringMid2, location: 0.40),
                .init(color: SOSColors.Primary.ringAccent, location: 0.65),
                .init(color: SOSColors.Primary.ringEnd, location: 1.00)
            ]),
            center: .center
        )
        
        static let specular = LinearGradient(
            colors: [SOSColors.highlightStrong, SOSColors.highlightWeak],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cancelStroke = LinearGradient(
            colors: [SOSColors.cancelStrokeTop, SOSColors.cancelStrokeBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    enum Sizes {
        static let sosButton: CGFloat = 112
        static let ring: CGFloat = 120
        static let sendingRing: CGFloat = 72
    }
}
