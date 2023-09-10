//
//  APIServiceMock.swift
//  WittyWeatherTests
//
//  Created by Felipe Lara on 10/09/2023.
//

import Foundation
import UIKit
@testable import WittyWeather

enum UnitTestError: Error {

    case noJson
}

class APIServiceMock: APIServiceType {

    var shouldThrowError: Bool
    var defaultBoolResults: Bool

    init(shouldThrowError: Bool,
         defaultBoolResults: Bool) {

        self.shouldThrowError = shouldThrowError
        self.defaultBoolResults = defaultBoolResults
    }

    func getForecast(city: City) async throws -> ForecastResponse {

        guard shouldThrowError == false else {

            throw ServiceError.genericError
        }

        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: "ForecastResponseExample", withExtension: "json") else {

            throw UnitTestError.noJson
        }

        let jsonData = try Data(contentsOf: jsonURL)

        return try JSONDecoder().decode(ForecastResponse.self, from: jsonData)
    }

    func getCity(cityName: String) async throws -> [City] {

        guard shouldThrowError == false else {

            throw ServiceError.genericError
        }

        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: "CityResponseExample", withExtension: "json") else {

            throw UnitTestError.noJson
        }

        let jsonData = try Data(contentsOf: jsonURL)

        return try JSONDecoder().decode([City].self, from: jsonData)
    }

    func getIcon(iconDesc: String) async throws -> UIImage {
        guard shouldThrowError == false else {
            throw ServiceError.genericError
        }
        return UIImage()
    }
}
