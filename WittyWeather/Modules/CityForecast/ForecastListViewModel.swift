//
//  View.swift
//  WittyWeather
//
//  Created by Felipe Lara on 10/09/2023.
//

import Foundation

class ForecastListViewModel: ObservableObject {

    enum ViewState {

        case loading
        case content([(String, [ForecastViewModel])])
        case error(String)
    }

    @Published var state: ViewState = .loading

    private var apiService: APIServiceType

    init(apiService: APIServiceType = APIService()) {

        self.apiService = apiService

        self.state = .loading
    }

    // MARK: - Functions
    func getForecast(city: City) async {

        do {

            let response = try await self.apiService.getForecast(city:city)

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

    // Group forecasts by day
    func groupedByDate(forecasts: [ForecastViewModel]) -> [(String, [ForecastViewModel])] {

        let groupedDictionary = Dictionary(grouping: forecasts) { forecast in

            forecast.day
        }

        return groupedDictionary.sorted { $0.key < $1.key }
    }
}
