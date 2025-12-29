//
//  SOSRecord.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 29.12.2025.
//

import Foundation
import CoreLocation

struct SOSRecord: Codable, Identifiable, Hashable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let date: Date
    var isResolved: Bool

    init(
        id: UUID = UUID(),
        latitude: Double,
        longitude: Double,
        date: Date = Date(),
        isResolved: Bool = false
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.isResolved = isResolved
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
