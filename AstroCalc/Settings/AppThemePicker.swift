//
//  AppThemePicker.swift
//  JourneyScan
//
//  Created by Ben Brackenbury on 12/04/2023.
//

import SwiftUI

//MARK: - Picker View
/**
 A Picker controler to an ``AppTheme``.
 
 Requires the ``UsePreferedTheme`` modifer to be applied to views that you wish this preference to be applied to.
 Usually, you want to apply this to your app's entry point.
 
 For example:
 ```
 @main
 struct MyApp: App {
     var body: some Scene {
         WindowGroup {
             ContentView()
                 .usePreferredTheme()
         }
     }
 }

 ```
 - Author: Ben Brackenbury
 */
struct AppThemePicker: View {
    @AppStorage("appTheme") var appTheme: AppTheme = .system
    
    var body: some View {
        Picker("Theme", selection: $appTheme) {
            ForEach(AppTheme.allCases) { theme in
                Text(theme.rawValue).tag(theme)
            }
        }
    }
}

struct AppThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        AppThemePicker()
    }
}


//MARK: - AppTheme Enum
/**
 Represents themes for the app

 - System
 - Light
 - Dark
 
 - Author: Ben Brackenbury
 */
enum AppTheme: String, CaseIterable, Identifiable, Codable {
    var id: UUID { UUID() }
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}


//MARK: - UsePreferedTheme custom View modifier
/**
 View Modifier to apply *prefersColorScheme()* to a view
 
 - Author: Ben Brackenbury
 */
fileprivate struct UsePreferedTheme: ViewModifier {
    /**
     Persistent ``AppTheme`` property which determines the
     app to use
     */
    @AppStorage("appTheme") var theme: AppTheme = .system
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(theme == .system ? .none : (theme == .light) ? .light : .dark)
    }
}

extension View {
    /**
     Applies the ``UsePreferedTheme`` modifier to a ``View``
     
     - Author: Ben Brackenbury
     */
    func usePreferredTheme() -> some View {
        modifier(UsePreferedTheme())
    }
}
