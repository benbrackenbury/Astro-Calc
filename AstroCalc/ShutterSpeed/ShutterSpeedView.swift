//
//  ShutterSpeedView.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 17/06/2020.
//

import SwiftUI

struct ShutterSpeedView: View {
    @AppStorage("focalLength") private var focalLength = ShutterSpeedCalculator.defaultFocalLength
    @AppStorage("isCropped") private var isCropped = 0
    @AppStorage("sensorCrop") private var sensorCrop = ShutterSpeedCalculator.defaultCropFactor

    @State private var showHelp = false
    @State private var showResetConfirmation = false
    @State private var resetCount = 0

    private var usesCropSensor: Bool { isCropped == 1 }

    private var effectiveCropFactor: Double {
        usesCropSensor ? sensorCrop : ShutterSpeedCalculator.fullFrameCropFactor
    }

    private var shutterSpeed: Double {
        ShutterSpeedCalculator.maximumShutterSpeed(
            focalLength: focalLength,
            cropFactor: effectiveCropFactor
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                focalLengthSection
                sensorCropSection
                resultSection
            }
            .navigationTitle("Shutter Speed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
        }
        .sheet(isPresented: $showHelp) {
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
            .presentationDragIndicator(.visible)
            .presentationContentInteraction(.scrolls)
        }
        .confirmationDialog("Reset form values?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
            Button("Reset to default", role: .destructive, action: resetToDefault)
        }
        .sensoryFeedback(.warning, trigger: showResetConfirmation) { _, presented in
            presented
        }
        .sensoryFeedback(.success, trigger: resetCount)
    }

    private var focalLengthSection: some View {
        Section("Focal Length") {
            Stepper(value: $focalLength, in: ShutterSpeedCalculator.minimumFocalLength...ShutterSpeedCalculator.maximumFocalLength, step: 1) {
                LabeledContent("Focal length") {
                    Text("\(focalLength, format: .number.precision(.fractionLength(0))) mm")
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }
            }
            .accessibilityValue("\(Int(focalLength)) millimeters")

            Slider(
                value: $focalLength,
                in: ShutterSpeedCalculator.minimumFocalLength...ShutterSpeedCalculator.maximumFocalLength,
                step: 1
            ) {
                Text("Focal length")
            } minimumValueLabel: {
                Text("\(Int(ShutterSpeedCalculator.minimumFocalLength))")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            } maximumValueLabel: {
                Text("\(Int(ShutterSpeedCalculator.maximumFocalLength))")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .accessibilityHidden(true)
            .tint(.accentColor)
        }
    }

    private var sensorCropSection: some View {
        Section {
            Picker("Sensor", selection: $isCropped) {
                Text("Full").tag(0)
                Text("Cropped").tag(1)
            }
            .pickerStyle(.segmented)
            .accessibilityLabel("Sensor type")

            if usesCropSensor {
                Stepper(value: $sensorCrop, in: ShutterSpeedCalculator.minimumCropFactor...ShutterSpeedCalculator.maximumCropFactor, step: ShutterSpeedCalculator.cropFactorStep) {
                    LabeledContent("Crop factor") {
                        Text(sensorCrop, format: .number.precision(.fractionLength(1)))
                            .monospacedDigit()
                            .contentTransition(.numericText())
                    }
                }
                .accessibilityValue("\(sensorCrop, format: .number.precision(.fractionLength(1)))")
            }
        } header: {
            Text("Sensor Crop")
        } footer: {
            Text(usesCropSensor
                 ? "Crop factor is applied to focal length in the 500 rule."
                 : "Full-frame sensors use a crop factor of 1.")
        }
    }

    private var resultSection: some View {
        Section {
            VStack(spacing: 8) {
                Text("Maximum shutter speed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(shutterSpeed, format: .number.precision(.fractionLength(2))) seconds")
                    .font(.largeTitle.weight(.bold).monospacedDigit())
                    .multilineTextAlignment(.center)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: shutterSpeed)
                    .frame(maxWidth: .infinity)
                    .accessibilityAddTraits(.updatesFrequently)
            }
            .padding(.vertical, 8)
            .accessibilityElement(children: .combine)
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarPinnedTrailing) {
            Button("Help", systemImage: "info.circle") {
                showHelp = true
            }
        }

        ToolbarOverflowMenu {
            Button("Reset Values", systemImage: "arrow.counterclockwise", role: .destructive) {
                showResetConfirmation = true
            }
            .labelStyle(.titleAndIcon)
        }
    }

    private func resetToDefault() {
        focalLength = ShutterSpeedCalculator.defaultFocalLength
        isCropped = 0
        sensorCrop = ShutterSpeedCalculator.defaultCropFactor
        resetCount += 1
    }
}

#Preview {
    ShutterSpeedView()
        .usePreferredTheme()
}
