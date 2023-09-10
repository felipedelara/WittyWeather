//
//  ForecastListViewModelTests.swift
//  WittyWeatherTests
//
//  Created by Felipe Lara on 10/09/2023.
//


import XCTest
@testable import WittyWeather

class ForecastListViewModelTests: XCTestCase {

    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    // MARK: - Tests
    func testLoadForecastWithSuccess() {

        // Arrange
        let apiMock = APIServiceMock(shouldThrowError: false, defaultBoolResults: true)
        let viewModel = ForecastListViewModel(apiService: apiMock)
        let expectation = XCTestExpectation(description: "Load forecasts with success")

        // Act
        Task {
            await viewModel.getForecast(city: City(name: "MockCity", localNames: nil, lat: 0, lon: 0, country: "PT", state: nil))

            try? await Task.sleep(nanoseconds: 500_000_000)

            guard case .content(let forecasts) = viewModel.state else {

                return XCTFail("Could not load content state. Current state is \(viewModel.state)")
            }

            // Assert
            XCTAssertEqual(forecasts.first!.0, "11-09-2023")
            XCTAssertEqual(forecasts.first!.1.first!.currentTemperatureCelsius, "7°C")
            XCTAssertEqual(forecasts.first!.1.first!.feelsLike, "21°C")

            XCTAssertEqual(forecasts.first!.1.last!.currentTemperatureCelsius, "24°C")
            XCTAssertEqual(forecasts.first!.1.last!.feelsLike, "24°C")

            XCTAssertEqual(forecasts.last!.0, "15-09-2023")
            XCTAssertEqual(forecasts.last!.1.first!.currentTemperatureCelsius, "19°C")
            XCTAssertEqual(forecasts.last!.1.first!.feelsLike, "19°C")

            XCTAssertEqual(forecasts.last!.1.last!.currentTemperatureCelsius, "39°C")
            XCTAssertEqual(forecasts.last!.1.last!.feelsLike, "26°C")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadCitiesWithFailute() {

        //  Arrange
        let apiMock = APIServiceMock(shouldThrowError: true, defaultBoolResults: true)
        let viewModel = CityListViewModel(apiService: apiMock)
        let expectation = XCTestExpectation(description: "Load cities with failure")

        // Act
        Task {
            await viewModel.getCities(query: "mock")

            try? await Task.sleep(nanoseconds: 500_000_000)

            guard case .error(let description) = viewModel.state else {

                XCTFail("Wrong state")
                return
            }
            
            // Assert
            XCTAssertEqual(description, "The operation couldn’t be completed. (WittyWeather.ServiceError error 2.)")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
