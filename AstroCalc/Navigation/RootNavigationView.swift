//
//  RootNavigationView.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 14/04/2023.
//  Copyright © 2023 Ben Brackenbury. All rights reserved.
//

import SwiftUI

struct RootNavigationView: View {
    @State private var selectedTab: AppTab

    init() {
        let stored = AppTab(rawValue: UserDefaults.standard.integer(forKey: "defaultTab")) ?? .shutterSpeed
        _selectedTab = State(initialValue: stored)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.shutterSpeed.title, systemImage: AppTab.shutterSpeed.iconName, value: AppTab.shutterSpeed) {
                ShutterSpeedView()
            }

            Tab(AppTab.settings.title, systemImage: AppTab.settings.iconName, value: AppTab.settings) {
                SettingsView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    RootNavigationView()
        .usePreferredTheme()
}
