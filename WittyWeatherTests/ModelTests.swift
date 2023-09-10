//
//  ModelTests.swift
//  WittyWeatherTests
//
//  Created by Felipe Lara on 10/09/2023.
//

import XCTest
@testable import WittyWeather

final class ModelTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testDecodingForecastResponseModel() throws {

        //Arrange
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: "ForecastResponseExample", withExtension: "json") else {

            XCTFail("JSON file not found.")
            return
        }

        let jsonData = try Data(contentsOf: jsonURL)

        //Act
        do {
            let listResponse = try JSONDecoder().decode(ForecastResponse.self, from: jsonData)

            // Assert
            XCTAssertEqual(listResponse.cod, "200")
            XCTAssertEqual(listResponse.message, 0)
            XCTAssertEqual(listResponse.cnt, 40)

            guard let firstForecastResult = listResponse.list.first else {

                XCTFail("Missing result")
                return
            }

            XCTAssertEqual(firstForecastResult.dt, 1694390400)
            XCTAssertEqual(firstForecastResult.main.temp, 295.49)
            XCTAssertEqual(firstForecastResult.weather.first!.id, 802)

        } catch {

            XCTFail("Error \(error)")
        }
    }

    func testDecodingCityResponseModel() throws {

        //Arrange
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: "CityResponseExample", withExtension: "json") else {

            XCTFail("JSON file not found.")
            return
        }

        let jsonData = try Data(contentsOf: jsonURL)

        //Act
        do {
            let listResponse = try JSONDecoder().decode([City].self, from: jsonData)

            // Assert
            XCTAssertEqual(listResponse.first!.name, "Lisbon")
            XCTAssertEqual(listResponse.first!.lat, 38.7077507)
            XCTAssertEqual(listResponse.first!.lon, -9.1365919)
            XCTAssertEqual(listResponse.first!.country, "PT")

        } catch {

            XCTFail("Error\(error)")
        }
    }
}
