//
//  ShutterSpeedView.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 17/06/2020.
//

import SwiftUI

struct ShutterSpeedView: View {
    @ObservedObject var vm = ShutterSpeedViewModel()
    @AppStorage("focalLength") var focalLength: Double = 35
    @AppStorage("isCropped") var isCropped: Int = 0
    @AppStorage("sensorCrop") var sensorCrop: Double = 1.1
    
    
    var body: some View {
        NavigationStack {
            Form {
                focalLengthSection
                sensorCropSection
                resultSection
            }            .navigationBarTitle("Shutter Speed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbar)
        }
        .sheet(isPresented: $vm.showInfo) {
            HelpView {
                Text("When taking pictures of the night sky, a maximum shutter speed exists, influenced by focal length and sensor crop factor.")
                
                Text("To calculate this we use the **500 Rule**:")
                
                VStack(spacing: 5) {
                    Text("Max shutter speed =")
                    Text("500 / (crop * focal length)")
                    .italic()
                }
            }
            .presentationDetents([.medium, .large])
        }
        .confirmationDialog("Reset form values?", isPresented: $vm.showResetAS, titleVisibility: .visible) {
            Button("Reset to default", role: .destructive, action: vm.resetToDefault)
        }
        
    }
    
    var focalLengthSection: some View {
        VStack(spacing: 30) {
            Stepper("Focal Length: \(String(format: "%.0f", focalLength)) mm", value: $focalLength, in: 1...300)
            
            Slider(value: $focalLength, in: 1...300, step: 1.0)
        }
    }
    
    var sensorCropSection: some View {
        Section(header: Text("Sensor Crop")) {
            Picker(selection: $isCropped, label: Text("")) {
                Text("Full").tag(0)
                Text("Cropped").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if isCropped == 1 {
                Stepper("Crop Factor: \(String(format: "%g", self.sensorCrop))", value: $sensorCrop, in: 1.1...1.9, step: 0.1)
            }
        }
    }
    
    var resultSection: some View {
        Section {
            VStack(spacing: 10) {
                Text("Maximum shutter speed:")
                Text(
                    (vm.shutterSpeed != nil)
                        ? String(format: "%.2f seconds", vm.shutterSpeed!)
                        : "0"
                )
                .font(.title.weight(.bold))
            }
        }
    }
    
    @ToolbarContentBuilder func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .secondaryAction) {
            Button(action: { vm.showInfo = true }) {
                Label("Help", systemImage: "info.circle")
            }
        }
        
        ToolbarItem(placement: .secondaryAction) {
            Button("Reset Values", role: .destructive) {
                let haptic = UINotificationFeedbackGenerator()
                haptic.notificationOccurred(.warning)
                vm.showResetAS = true
            }
        }
    }

}

struct ShutterSpeedView_Previews: PreviewProvider {
    static var previews: some View {
        ShutterSpeedView()
    }
}
