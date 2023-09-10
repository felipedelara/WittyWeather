//
//  CityListViewModelTests.swift
//  WittyWeatherTests
//
//  Created by Felipe Lara on 10/09/2023.
//

import XCTest
@testable import WittyWeather

class CityListViewModelTests: XCTestCase {

    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    // MARK: - Tests
    func testLoadCitiesWithSuccess() {

        // Arrange
        let apiMock = APIServiceMock(shouldThrowError: false, defaultBoolResults: true)
        let viewModel = CityListViewModel(apiService: apiMock)
        let expectation = XCTestExpectation(description: "Load cities with success")

        // Act
        Task {
            await viewModel.getCities(query: "mock")

            try? await Task.sleep(nanoseconds: 500_000_000)

            // Assert
            guard case .content(let cities) = viewModel.state else {

                XCTFail("Could not load content state. Current state is \(viewModel.state)")
                return
            }

            // Assert
            XCTAssertEqual(cities.first!.name, "Lisbon")
            XCTAssertEqual(cities.first!.lat, 38.7077507)
            XCTAssertEqual(cities.first!.lon, -9.1365919)
            XCTAssertEqual(cities.first!.country, "PT")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadCitiesWithFailute() {

        //  Arrange
        let apiMock = APIServiceMock(shouldThrowError: true, defaultBoolResults: true)
        let viewModel = CityListViewModel(apiService: apiMock)
        let expectation = XCTestExpectation(description: "Load cities with failure")

        // Act:
        Task {
            await viewModel.getCities(query: "mock")

            try? await Task.sleep(nanoseconds: 500_000_000)

            // Assert
            guard case .error(let description) = viewModel.state else {

                XCTFail("Wrong state")
                return
            }

            XCTAssertEqual(description, "The operation couldn’t be completed. (WittyWeather.ServiceError error 2.)")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
