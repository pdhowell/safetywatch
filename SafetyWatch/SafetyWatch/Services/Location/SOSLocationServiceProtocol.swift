//
//  SOSLocationServiceProtocol.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation
import CoreLocation

protocol SOSLocationServiceProtocol: AnyObject {
    func requestLocation(_ completion: @escaping (Result<CLLocation, Error>) -> Void)
}
