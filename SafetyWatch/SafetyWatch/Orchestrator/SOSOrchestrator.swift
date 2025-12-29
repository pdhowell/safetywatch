//
//  SOSOrchestrator.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation
import CoreLocation

@MainActor
final class SOSOrchestrator: ObservableObject {
    
    @Published var logs: [String] = []
    @Published var shareText: String = ""
    @Published var lastCoordinate: CLLocationCoordinate2D?
    @Published var lastRecord: SOSRecord?
    @Published var history: [SOSRecord] = []
    
    private let locationService: SOSLocationServiceProtocol
    private let connectivity: SOSPhoneConnectivityProtocol
    
    private var sosOperationId = UUID()
    
    init(
        locationService: SOSLocationServiceProtocol = SOSLocationService(),
        connectivity: SOSPhoneConnectivityProtocol = SOSPhoneConnectivity.shared
    ) {
        self.locationService = locationService
        self.connectivity = connectivity
    }
    
    func start() {
        reloadFromStorage()
        
        connectivity.start()
        connectivity.onStartSOS = { [weak self] in
            Task { @MainActor in
                self?.handleStartSOS(source: "watch")
            }
        }
        
        log("Ready")
    }
    
    func stop() {
        connectivity.onStartSOS = nil
    }
    
    func clearHistory() {
        sosOperationId = UUID()
        
        SOSHistoryStorage.clearAll()
        history = []
        lastRecord = nil
        lastCoordinate = nil
        shareText = ""
        
        log("History cleared")
    }
    
    func handleStartSOS(source: String) {
        let opId = sosOperationId
        
        log("SOS received (\(source))")
        log("Requesting location…")
        
        locationService.requestLocation { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                guard self.sosOperationId == opId else { return }
                
                switch result {
                case .success(let location):
                    let coord = location.coordinate
                    
                    self.lastCoordinate = coord
                    self.shareText = self.makeShareText(for: coord)
                    
                    let record = SOSHistoryStorage.append(coordinate: coord)
                    self.history = SOSHistoryStorage.load()
                    self.lastRecord = record
                    
                    self.connectivity.sendStatusToWatch(status: "sent")
                    self.log("Status -> Watch: sent")
                    
                case .failure(let error):
                    self.log("Location error: \(error.localizedDescription)")
                    
                    self.connectivity.sendStatusToWatch(status: "failed")
                    self.log("Status -> Watch: failed")
                }
            }
        }
    }
    
    private func reloadFromStorage() {
        history = SOSHistoryStorage.load()
        lastRecord = history.first
        
        if let lastRecord {
            lastCoordinate = lastRecord.coordinate
            shareText = makeShareText(for: lastRecord.coordinate)
        } else {
            lastCoordinate = nil
            shareText = ""
        }
    }
    
    private func makeShareText(for coordinate: CLLocationCoordinate2D) -> String {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        let link = "https://maps.apple.com/?ll=\(lat),\(lon)"
        return "SOS! Я здесь: \(link)"
    }
    
    private func log(_ text: String) {
        logs.insert("[\(DateFormatter.shortTime.string(from: Date()))] \(text)", at: 0)
    }
}

private extension DateFormatter {
    static let shortTime: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f
    }()
}
