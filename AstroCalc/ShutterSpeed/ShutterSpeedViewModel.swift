//
//  ShutterSpeedViewModel.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 14/04/2023.
//  Copyright © 2023 Ben Brackenbury. All rights reserved.
//

import SwiftUI
import Combine

class ShutterSpeedViewModel: ObservableObject {
    @AppStorage("focalLength") var focalLength: Double = 35
    @AppStorage("isCropped") var isCropped: Int = 0
    @AppStorage("sensorCrop") var sensorCrop: Double = 1.1
    
    @Published var shutterSpeed: Float? = nil
    @Published var showInfo: Bool = false
    @Published var showResetAS: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    deinit {
        cancellables.forEach{$0.cancel()}
    }
    
    private func setupSubscriptions() {
        objectWillChange
            .debounce(for: 0.01, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                print("")
                self?.calculate()
            }
            .store(in: &cancellables)
    }
    
    func calculate() {
        if self.isCropped == 0 {
            self.sensorCrop = 1
        }
        self.shutterSpeed = Float(500 / (CGFloat(self.sensorCrop) * CGFloat(self.focalLength)))
    }
    
    func resetToDefault() {
        let haptic = UINotificationFeedbackGenerator()
        haptic.notificationOccurred(.success)
        
        self.focalLength = 35
        self.isCropped = 0
        self.sensorCrop = 1.1
        self.shutterSpeed = 0
    }
}

