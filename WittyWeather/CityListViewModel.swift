//
//  CityListViewModel.swift
//  WittyWeather
//
//  Created by Felipe Lara on 09/09/2023.
//

import Foundation

class CityListViewModel: ObservableObject {

    enum ViewState {

        case loading
        case content([CityGeocoding])
        case error(String)
    }

    // MARK: - Published properties
    @Published var state: ViewState = .loading

    private var apiService: APIServiceType
    init(apiService: APIServiceType = APIService()) {

        self.apiService = apiService

        Task {

            await self.getCity(name: "Curitiba")
        }
    }

    // MARK: - Functions
    func getCity(name: String) async {

        DispatchQueue.main.async {

            self.state = .loading
        }

        do {
            // Sleep for half a second. Nicer effect visually
            try await Task.sleep(nanoseconds: 500_000_000)

            let cities = try await apiService.getCityGeocoding(cityName: name)

            DispatchQueue.main.async {

                self.state = .content(cities)
            }
        } catch {

            DispatchQueue.main.async {

                switch error as? ServiceError {
                case .noToken:
                    self.state = .error("No API token found. Please go to Settings and insert one.")
                case .invalidUrl:
                    self.state = .error("An invalid request has been attempted. Please contact support.")
                case .none, .genericError:
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
}
