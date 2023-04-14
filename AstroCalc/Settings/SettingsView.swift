//
//  SettingsView.swift
//  JourneyScan
//
//  Created by Ben Brackenbury on 12/04/2023.
//

import SwiftUI
import WidgetKit
import StoreKit

struct SettingsView: View {
    @AppStorage("defaultTab") var defaultTab: Tab.ID = .shutterSpeed.id
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General") { generalSection }
                Section("Appearance") {  appearanceSection }
                Section("About") {  aboutSection }
                Section("Advanced") {
                    NavigationLink("Advanced", destination: AdvancedSettingsView())
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    var generalSection: some View {
        Group {
            Picker("Default Tab", selection: $defaultTab) {
                ForEach(Tab.allCases.filter{$0 != .settings}) { tab in
                    tab.label.tag(tab.id)
                }
            }
        }
    }
    
    var appearanceSection: some View {
        Group {
            AppThemePicker()
        }
    }
    
    var aboutSection: some View {
        Group {
            Text(Bundle.appDisplayName)
            LabeledContent("Version", value: Bundle.appVersion)
            Button("Review \(Bundle.appDisplayName)") {
                Task { await requestReview() }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


extension Bundle {
    static var appDisplayName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown"
    }
    
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    }
}
