//
//  AdvancedSettingsView.swift
//  JourneyScan
//
//  Created by Ben Brackenbury on 12/04/2023.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @State private var showResetSettingsConfirm = false
    @State private var showResetSettingsSuccessful = false

    var body: some View {
        Form {
            Section {
                Button("Reset Settings", role: .destructive) {
                    showResetSettingsConfirm = true
                }
            } footer: {
                Text("Restores theme, default tab, and shutter speed inputs to their original values.")
            }
        }
        .navigationTitle("Advanced")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
        .confirmationDialog("Reset Settings?", isPresented: $showResetSettingsConfirm, titleVisibility: .visible) {
            Button("Reset", role: .destructive, action: resetUserDefaults)
        } message: {
            Text("This cannot be undone.")
        }
        .alert("Settings have been reset to defaults", isPresented: $showResetSettingsSuccessful) {
            Button("OK", role: .cancel) {}
        }
        .sensoryFeedback(.warning, trigger: showResetSettingsConfirm) { _, presented in
            presented
        }
        .sensoryFeedback(.success, trigger: showResetSettingsSuccessful) { _, presented in
            presented
        }
    }

    /**
     Resets UserDefaults and shows confirmation dialog.

     - Warning: The function will not do anything if ``Bundle.main.bundleIdentifier``
     is ``nil``.
     - Author: Ben Brackenbury
     */
    private func resetUserDefaults() {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
        showResetSettingsSuccessful = true
    }
}

#Preview {
    NavigationStack {
        AdvancedSettingsView()
    }
}
