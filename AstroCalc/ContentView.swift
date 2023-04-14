//
//  ContentView.swift
//  Photography
//
//  Created by Ben Brackenbury on 17/06/2020.
//

import SwiftUI

struct InitialState {
    var focalLength: Double
    var isCropped: Int
    var sensorCrop: Float
}

struct ContentView: View {
    
    @State var focalLength: Double = UserDefaults.standard.double(forKey: "focalLength")
    @State var isCropped: Int = UserDefaults.standard.integer(forKey: "isCropped")
    @State var sensorCrop: Float = UserDefaults.standard.float(forKey: "sensorCrop")
    @State var hasChanged: Bool = false
    @State var hasBeenCalculated: Bool = false
    @State var shutterSpeed: Float? = nil
    @State var showInfo: Bool = false
    @State var showResetAS: Bool = false
    let accentColorStr: String = "AD4760"
    
    @State var initialState: InitialState = InitialState(
        focalLength: UserDefaults.standard.double(forKey: "focalLength"),
        isCropped:   UserDefaults.standard.integer(forKey: "isCropped"),
        sensorCrop:  UserDefaults.standard.float(forKey: "sensorCrop")
    )
    
    func warningTaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    func didChange() {
        
        self.hasChanged = true
        self.hasBeenCalculated = false
        
        self.calculate()
    }
    
    func save() {
        UserDefaults.standard.set(self.focalLength, forKey: "focalLength")
        UserDefaults.standard.set(self.isCropped, forKey: "isCropped")
        UserDefaults.standard.set(self.sensorCrop, forKey: "sensorCrop")
    }
    
    func calculate() {
        if self.isCropped == 0 {
            self.sensorCrop = 1
        }
        self.shutterSpeed = Float(500 / (CGFloat(self.sensorCrop) * CGFloat(self.focalLength)))
        self.hasBeenCalculated = true
        
        self.save()
    }
    
    func resetToDefault() {
        self.focalLength = 35
        self.isCropped = 0
        self.sensorCrop = 1.1
        self.shutterSpeed = 0
        self.hasChanged = false
        self.hasBeenCalculated = false
        
        self.save()
        self.didChange()
    }
    
    func resetToInitState() {
        self.focalLength = self.initialState.focalLength
        self.isCropped = self.initialState.isCropped
        self.sensorCrop = self.initialState.sensorCrop
        self.shutterSpeed = 0
        self.hasChanged = false
        self.hasBeenCalculated = false
        
        self.didChange()
    }
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Calculate the maximum shutter speed to avoid star trails")
                        .font(.callout)
                        .opacity(0.7)
                    Spacer()
                    Button(action: {
                        self.showInfo = true
                    }) {
                        Image(systemName: "info.circle")
                        .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .accentColor(Color.init(hex: self.accentColorStr))
                    .sheet(isPresented: self.$showInfo) {
                        NavigationView {
                            VStack(spacing: 15) {
                                Text("How this works")
                                    .font(.title).bold()
                                
                                Text("When taking pictures of the night sky, a maximum shutter speed exists, influenced by focal length and sensor crop factor.")
                                
                                HStack(spacing: 0) {
                                    Text("To calculate this we use the ")
                                    Text("500 Rule").bold()
                                    Text(":")
                                }
                                
                                VStack(spacing: 5) {
                                    Text("Max shutter speed =")
                                    Text("500 / (crop * focal length)")
                                    .italic()
                                }
                                    .padding([.vertical])
                                
                                Spacer()
                            }
                            .padding()
                                
                            .navigationBarItems(trailing:
                                Button(action: {
                                    self.showInfo = false
                                }) {
                                    Text("Done").bold()
                                }
                                .accentColor(Color.init(hex: self.accentColorStr))
                            )
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
                    .padding()
                }
                .padding()
                
                VStack(spacing: 30) {
                    Stepper("Focal Length: \(String(format: "%.0f", focalLength)) mm", value: $focalLength, in: 1...300, onEditingChanged: {_ in self.didChange()})
                    
                    Slider(value: $focalLength.onChange({_ in self.didChange()}), in: 1...300, step: 1.0)
                        .accentColor(Color.init(hex: "C9786B"))
                    
                    Section(header: Text("Sensor Crop")) {
                        Picker(selection: $isCropped.onChange({_ in self.didChange()}), label: Text("")) {
                            Text("Full").tag(0)
                            Text("Cropped").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding([.horizontal])
                        .padding(.top, -20)
                        
                        if isCropped == 1 {
                            Stepper("Crop Factor: \(String(format: "%g", self.sensorCrop))", value: $sensorCrop, in: 1.1...1.9, step: 0.1, onEditingChanged: {_ in self.didChange()})
                        }
                    }
                    
                    Section {
                        VStack(spacing: 10) {
                            Text("Maximum shutter speed:")
                            Text(
                                (self.shutterSpeed != nil)
                                    ? String(format: "%.2f seconds", self.shutterSpeed!)
                                    : "0"
                            )
                            .font(.title)
                            .bold()
                            .onAppear(perform: {
                                if self.shutterSpeed == nil {
                                    self.didChange()
                                }
                            })
                        }
                    }
                    .padding(.top, 25)
                    .opacity(self.hasBeenCalculated ? 1 : 0.3)
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text("Version \(ContentView.self.appVersion!)")
                        .font(.system(size: 12, weight: .light, design: .default))
                        .opacity(0.6)
                    Spacer()
                }
                .padding(.bottom, 5)
            }
            
            .navigationBarTitle(Text("Astro Calc"))
            .navigationBarItems(
                leading:
                Button("Reset") {
                    self.showResetAS = true
                    self.warningTaptic()
                }
                .accentColor(Color.init(hex: self.accentColorStr))
                .actionSheet(isPresented: self.$showResetAS) {
                    ActionSheet(title: Text("Reset"), buttons: [
                        .destructive(Text("Reset to default")) {self.resetToDefault()},
                        .destructive(Text("Reset to initial state (app loaded)")) {self.resetToInitState()},
                        .cancel()
                    ])
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
