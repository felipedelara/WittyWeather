//
//  ForecastViewModel.swift
//  WittyWeather
//
//  Created by Felipe Lara on 10/09/2023.
//

import Foundation
import SwiftUI

class ForecastViewModel {

    let day: String
    let hour: String
    let icon: () -> Image
    let currentTemperatureCelsius: String
    let maxTemperatureCelsius: String
    let minTemperatureCelsius: String
    let description: String

    init?(forecast: Forecast) {

        guard let weather = forecast.weather.first else { return nil }

        self.day = forecast.dtTxt.formatDate()

        self.hour = forecast.dtTxt.hourFromDate()

        self.icon = {

            return Image("sun.min")
        }

        self.currentTemperatureCelsius = Self.convertTemp(temp: Double(forecast.main.tempMin), from: .kelvin, to: .celsius)
        self.maxTemperatureCelsius = Self.convertTemp(temp: Double(forecast.main.tempMin), from: .kelvin, to: .celsius)
        self.minTemperatureCelsius = Self.convertTemp(temp: Double(forecast.main.tempMin), from: .kelvin, to: .celsius)

        self.description = weather.description
    }

    static func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {

        let measurementFormatter = MeasurementFormatter()

        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .providedUnit

        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)

        return measurementFormatter.string(from: output)
    }
}

