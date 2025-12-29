//
//  SOSWatchViewModel.swift
//  SafetyWatch Watch App Watch App
//
//  Created by Matvei Khlestov on 28.12.2025.
//

import Foundation

@MainActor
final class SOSWatchViewModel: ObservableObject {
    
    enum State: Equatable {
        case idle
        case countdown(secondsLeft: Int)
        case sending
        case sent
        case failed
    }
    
    @Published var state: State = .idle
    
    private var timer: Timer?
    private let totalSeconds: Int = 5
    
    private let connectivity: SOSConnectivityProtocol
    private let haptics: SOSHapticsServiceProtocol
    
    init(
        connectivity: SOSConnectivityProtocol = SOSConnectivity.shared,
        haptics: SOSHapticsServiceProtocol = SOSHapticsService()
    ) {
        self.connectivity = connectivity
        self.haptics = haptics
        
        self.connectivity.onStatus = { [weak self] status in
            Task { @MainActor in
                self?.setStatusFromPhone(status)
            }
        }
    }
    
    func startCountdown() {
        guard state == .idle else { return }
        
        haptics.click()
        haptics.notification()
        
        state = .countdown(secondsLeft: totalSeconds)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.tick()
            }
        }
    }
    
    func cancel() {
        timer?.invalidate()
        timer = nil
        
        haptics.click()
        haptics.success()
        
        state = .idle
    }
    
    func setStatusFromPhone(_ status: String) {
        if status == "sent" {
            haptics.success()
            state = .sent
        } else {
            haptics.failure()
            state = .failed
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            self?.state = .idle
        }
    }
    
    var progress: Double {
        guard case let .countdown(s) = state else { return 0 }
        return 1.0 - Double(totalSeconds - s) / Double(totalSeconds)
    }
    
    private func tick() {
        guard case let .countdown(s) = state else { return }
        let next = s - 1
        
        if next <= 3 && next > 0 {
            haptics.click()
        }
        
        if next <= 0 {
            timer?.invalidate()
            timer = nil
            
            state = .sending
            haptics.directionUp()
            
            connectivity.sendStartSOS()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
                guard let self else { return }
                if self.state == .sending {
                    self.setStatusFromPhone("failed")
                }
            }
        } else {
            state = .countdown(secondsLeft: next)
        }
    }
}
