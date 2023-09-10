//
//  TemperatureConverterTests.swift
//  WittyWeatherTests
//
//  Created by Felipe Lara on 10/09/2023.
//

import Foundation

import XCTest
@testable import WittyWeather

class TemperatureConverterTests: XCTestCase {

    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    // MARK: - Tests
    func testConvertsTemperaturesWithSuccess() {

        // Arrange
        let kelvinTemperatures: [Double] = [
        298.15, 303.25, 289.35, 310.45, 282.55
        ]

        let expectedCelciusResults: [String] = [
            "25°C", "30°C", "16°C", "37°C", "9°C"
        ]

        // Act
        var calculatedCelcius = [String]()
        for item in kelvinTemperatures {

            calculatedCelcius.append(TemperatureConverter.convertTemp(temp: item, from: .kelvin, to: .celsius))
        }

        // Assert

        for (expected, calculated) in zip(expectedCelciusResults, calculatedCelcius) {

            XCTAssertEqual(expected, calculated)
        }
    }
}
