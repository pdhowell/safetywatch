//
//  SOSLocationService.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation
import CoreLocation

final class SOSLocationService: NSObject, CLLocationManagerDelegate, SOSLocationServiceProtocol {

    enum LocationError: LocalizedError {
        case permissionDenied
        case permissionRestricted
        case unableToGetAuthorization

        var errorDescription: String? {
            switch self {
            case .permissionDenied:
                return "Location permission denied."
            case .permissionRestricted:
                return "Location permission restricted."
            case .unableToGetAuthorization:
                return "Unable to get location authorization."
            }
        }
    }

    private let manager = CLLocationManager()
    private var completion: ((Result<CLLocation, Error>) -> Void)?
    private var isWaitingForAuthorization = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation(_ completion: @escaping (Result<CLLocation, Error>) -> Void) {
        self.completion = completion

        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            isWaitingForAuthorization = true
            manager.requestWhenInUseAuthorization()

        case .restricted:
            finish(.failure(LocationError.permissionRestricted))

        case .denied:
            finish(.failure(LocationError.permissionDenied))

        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()

        @unknown default:
            finish(.failure(LocationError.unableToGetAuthorization))
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard isWaitingForAuthorization else { return }
        isWaitingForAuthorization = false

        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied:
            finish(.failure(LocationError.permissionDenied))
        case .restricted:
            finish(.failure(LocationError.permissionRestricted))
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        finish(.success(loc))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finish(.failure(error))
    }

    private func finish(_ result: Result<CLLocation, Error>) {
        completion?(result)
        completion = nil
    }
}

