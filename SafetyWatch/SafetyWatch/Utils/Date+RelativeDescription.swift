//
//  Date+RelativeDescription.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 29.12.2025.
//

import Foundation

extension Date {

    var relativeDescription: String {
        let seconds = Int(Date().timeIntervalSince(self))
        if seconds < 10 { return "just now" }

        let minutes = seconds / 60
        if minutes < 1 { return "just now" }
        if minutes < 60 { return "\(minutes) min ago" }

        let hours = minutes / 60
        if hours < 24 { return "\(hours) hour\(hours == 1 ? "" : "s") ago" }

        let days = hours / 24
        if days == 1 { return "yesterday" }
        return "\(days) days ago"
    }
}
