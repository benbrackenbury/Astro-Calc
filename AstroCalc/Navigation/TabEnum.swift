//
//  TabEnum.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 14/04/2023.
//  Copyright © 2023 Ben Brackenbury. All rights reserved.
//

import SwiftUI

enum Tab: Int, View, CaseIterable, Hashable, Identifiable {
    var id: Self { self }
    
    case shutterSpeed
    case settings
    
    var body: some View {
        switch self {
        case .shutterSpeed:
            ShutterSpeedView()
        case .settings:
            SettingsView()
        }
    }
    
    var title: String {
        switch self {
        case .shutterSpeed:
            return "Shutter Speed"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .shutterSpeed:
            return "stopwatch"
        case .settings:
            return "gear"
        }
    }
    
    var label: some View {
        Label(title, systemImage: iconName)
    }
    
    @ViewBuilder func tabItem() -> some View {
        self
            .tabItem{label}
            .tag(self.id)
    }
}
