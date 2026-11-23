//
//  TabEnum.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 14/04/2023.
//  Copyright © 2023 Ben Brackenbury. All rights reserved.
//

import SwiftUI

enum AppTab: Int, CaseIterable, Hashable, Identifiable {
    case shutterSpeed
    case settings

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .shutterSpeed:
            "Shutter Speed"
        case .settings:
            "Settings"
        }
    }

    var iconName: String {
        switch self {
        case .shutterSpeed:
            "stopwatch"
        case .settings:
            "gear"
        }
    }
}
