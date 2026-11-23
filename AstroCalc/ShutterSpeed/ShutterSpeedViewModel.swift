//
//  ShutterSpeedViewModel.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 14/04/2023.
//  Copyright © 2023 Ben Brackenbury. All rights reserved.
//

import Foundation

enum ShutterSpeedCalculator {
    static let ruleConstant: Double = 500
    static let defaultFocalLength: Double = 35
    static let defaultCropFactor: Double = 1.1
    static let fullFrameCropFactor: Double = 1
    static let minimumFocalLength: Double = 1
    static let maximumFocalLength: Double = 300
    static let minimumCropFactor: Double = 1.1
    static let maximumCropFactor: Double = 1.9
    static let cropFactorStep: Double = 0.1

    static func maximumShutterSpeed(focalLength: Double, cropFactor: Double) -> Double {
        let length = min(max(focalLength, minimumFocalLength), maximumFocalLength)
        let crop = min(max(cropFactor, fullFrameCropFactor), maximumCropFactor)
        return ruleConstant / (crop * length)
    }
}
