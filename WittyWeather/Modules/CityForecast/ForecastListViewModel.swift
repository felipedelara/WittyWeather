//
//  View.swift
//  WittyWeather
//
//  Created by Felipe Lara on 10/09/2023.
//

import Foundation
import CoreData
import SwiftUI
class ForecastListViewModel: ObservableObject {

    enum ViewState {

        case loading
        case content([(String, [ForecastViewModel])])
        case error(String)
    }

    // MARK: Private properties
    private var apiService: APIServiceType
    @Environment(\.managedObjectContext) var managedObjectContext

    // MARK: Published properties
    @Published var state: ViewState = .loading

    let city: City

    // MARK: Lifecycle
    init(apiService: APIServiceType = APIService(),
         city: City) {

        self.apiService = apiService
        self.state = .loading
        self.city = city
    }

    // MARK: - Public functions
    public func loadForecast() async {

        do {

            let response = try await self.apiService.getForecast(city: self.city)

            DispatchQueue.main.async {

                let viewModels = response.list.compactMap { ForecastViewModel(forecast: $0) }
                let groupedByDate = self.groupedByDate(forecasts: viewModels)
                self.state = .content(groupedByDate)
            }

        } catch {

            DispatchQueue.main.async {

                switch error as? ServiceError {
                case .noToken:
                    self.state = .error("No API token found. Please go to Settings and insert one.")
                case .invalidUrl:
                    self.state = .error("An invalid request has been attempted. Please contact support.")
                case .none, .genericError, .badImageFromDataConversion:
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Private functions
private extension ForecastListViewModel {

    func saveForecastsLocally(_ forecastViewModels: [ForecastViewModel]) {

        for forecastViewModel in forecastViewModels {

            let coreForecast = CoreForecast(context: self.managedObjectContext)
            coreForecast.currentTemp = forecastViewModel.currentTemperatureCelsius
            coreForecast.day = forecastViewModel.day
            coreForecast.hour = forecastViewModel.hour
            coreForecast.icon = forecastViewModel.icon
            coreForecast.feelsLike = forecastViewModel.feelsLike
            coreForecast.dt = Int64(forecastViewModel.dt)

            /*  This is where I realized I made a design mistake (still learning CoreData). Originally this had a relatioship with CoreCity.
                CoreData wants to keep graph relations but I constructed it having in mind something closer to a relational database.
                Workaroung: storing the hash of the city model, which will garantee me something closer to an ID that I can always recreate from the API models and fetch from CoreData.
             */
            coreForecast.cityHash = Int64(self.city.hashValue)
        }
    }

    func loadStoredForecasts(for city: City) throws-> [ForecastViewModel] {

        let fetchRequest: NSFetchRequest<CoreForecast> = CoreForecast.fetchRequest()

        let coreForecasts = try managedObjectContext.fetch(fetchRequest)

        var results = [ForecastViewModel]()

        for coreForecast in coreForecasts {

            if let forecastViewModel = ForecastViewModel(coreForecast: coreForecast) {

                results.append(forecastViewModel)
            }
        }

        return results
    }

    // Group forecasts by day
    func groupedByDate(forecasts: [ForecastViewModel]) -> [(String, [ForecastViewModel])] {

        let groupedDictionary = Dictionary(grouping: forecasts) { forecast in

            forecast.day
        }

        return groupedDictionary.sorted { $0.key < $1.key }
    }
}
