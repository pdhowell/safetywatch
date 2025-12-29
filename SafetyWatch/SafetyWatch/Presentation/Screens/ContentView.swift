//
//  ContentView.swift
//  SafetyWatch
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import SwiftUI
import CoreLocation
import Combine

struct ContentView: View {
    
    @StateObject private var orchestrator = SOSOrchestrator()
    @State private var mapRoute: SOSMapRoute?
    @State private var didFinishInitialLoad: Bool = false
    
    var body: some View {
        NavigationStack {
            WaitingView(
                lastRecord: orchestrator.lastRecord,
                history: $orchestrator.history,
                onOpenLastSOS: openLastSOS,
                onOpenHistoryItem: openHistoryItem,
                onClearHistory: { orchestrator.clearHistory() }
            )
            .navigationDestination(item: $mapRoute) { route in
                SOSMapView(
                    coordinate: route.coordinate,
                    shareText: orchestrator.shareText
                )
            }
            .onReceive(
                orchestrator.$lastRecord
                    .compactMap { $0 }
                    .removeDuplicates(by: { a, b in a.id == b.id })
            ) { record in
                guard didFinishInitialLoad else { return }
                mapRoute = SOSMapRoute(record: record)
            }
            .onAppear {
                orchestrator.start()
                DispatchQueue.main.async {
                    didFinishInitialLoad = true
                }
            }
            .onDisappear { orchestrator.stop() }
        }
    }
    
    private func openLastSOS() {
        guard let record = orchestrator.lastRecord else { return }
        mapRoute = SOSMapRoute(record: record)
    }
    
    private func openHistoryItem(_ record: SOSRecord) {
        mapRoute = SOSMapRoute(record: record)
    }
}
