//
//  AdvancedSettingsView.swift
//  JourneyScan
//
//  Created by Ben Brackenbury on 12/04/2023.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @State private var showResetSettingsConfirm = false
    @State private var showResetSettingsSuccesful = false
    
    var body: some View {
        Form {
            Button("Reset Settngs", role: .destructive, action: {
                showResetSettingsConfirm = true
                let haptic = UINotificationFeedbackGenerator()
                haptic.notificationOccurred(.warning)
            })
            .confirmationDialog("Reset Settings?", isPresented: $showResetSettingsConfirm, titleVisibility: .visible, actions: {
                Button("Reset", role: .destructive, action: resetUserDefaults)
            }, message: {
                Text("This cannot be undone.")
            })
            .alert("Settings have been reset to defaults", isPresented: $showResetSettingsSuccesful) {
                Button("Ok"){}
            }
        }
        .navigationTitle("Advanced")
        .navigationBarTitleDisplayMode(.inline)
    }
}


//MARK: - Extension
extension AdvancedSettingsView {
    /**
     Resets UserDefaults and shows confirmation dialog.
     
     - Warning: The function will not do anything if ``Bundle.main.bundleIdentifier``
     is ``nil``.
     - Author: Ben Brackenbury
     */
    func resetUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(.success)
            showResetSettingsSuccesful = true
        }
    }
}


struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AdvancedSettingsView()
        }
    }
}
