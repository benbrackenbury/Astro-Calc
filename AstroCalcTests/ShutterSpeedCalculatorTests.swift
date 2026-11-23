import Foundation
import Testing
@testable import AstroCalc

struct ShutterSpeedCalculatorTests {
    @Test func fullFrame35mmMatches500Rule() {
        let speed = ShutterSpeedCalculator.maximumShutterSpeed(focalLength: 35, cropFactor: 1)
        #expect(abs(speed - 500.0 / 35.0) < 0.0001)
    }

    @Test func croppedSensorShortensExposure() {
        let fullFrame = ShutterSpeedCalculator.maximumShutterSpeed(focalLength: 50, cropFactor: 1)
        let cropped = ShutterSpeedCalculator.maximumShutterSpeed(focalLength: 50, cropFactor: 1.5)
        #expect(cropped < fullFrame)
        #expect(abs(cropped - 500.0 / (1.5 * 50.0)) < 0.0001)
    }

    @Test func clampsInvalidFocalLength() {
        let tooLow = ShutterSpeedCalculator.maximumShutterSpeed(focalLength: 0, cropFactor: 1)
        let minimum = ShutterSpeedCalculator.maximumShutterSpeed(focalLength: 1, cropFactor: 1)
        #expect(tooLow == minimum)
    }
}
