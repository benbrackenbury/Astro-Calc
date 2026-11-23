//
//  SettingsView.swift
//  JourneyScan
//
//  Created by Ben Brackenbury on 12/04/2023.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("defaultTab") private var defaultTab = AppTab.shutterSpeed
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        NavigationStack {
            Form {
                Section("General") { generalSection }
                Section("Appearance") { appearanceSection }
                Section("About") { aboutSection }
                Section("Advanced") {
                    NavigationLink("Advanced") {
                        AdvancedSettingsView()
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
        }
    }

    private var generalSection: some View {
        Picker("Default Tab", selection: $defaultTab) {
            ForEach(AppTab.allCases.filter { $0 != .settings }) { tab in
                Label(tab.title, systemImage: tab.iconName)
                    .tag(tab)
            }
        }
        .accessibilityHint("The tab shown when the app launches.")
    }

    private var appearanceSection: some View {
        AppThemePicker()
    }

    private var aboutSection: some View {
        Group {
            LabeledContent("App", value: Bundle.appDisplayName)
            LabeledContent("Version", value: Bundle.appVersion)
            Button("Review \(Bundle.appDisplayName)") {
                requestReview()
            }
        }
    }
}

#Preview {
    SettingsView()
        .usePreferredTheme()
}

extension Bundle {
    static var appDisplayName: String {
        let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        return displayName ?? bundleName ?? "Astro Calc"
    }

    static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    }
}
