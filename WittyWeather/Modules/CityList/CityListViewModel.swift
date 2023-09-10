//
//  CityListViewModel.swift
//  WittyWeather
//
//  Created by Felipe Lara on 09/09/2023.
//

import Foundation
import Combine

class CityListViewModel: ObservableObject {

    var allCities: Set<City> = [] // Sets will avoid duplicates

    enum ViewState {

        case loading
        case content([City])
        case error(String)
    }

    // MARK: - Published properties
    @Published var state: ViewState = .loading

    var subscription: Set<AnyCancellable> = []

    @Published var searchQuery: String = String()

    private var apiService: APIServiceType

    init(apiService: APIServiceType = APIService()) {

        self.apiService = apiService

        self.state = .loading

        Task {

            await self.getCities(query: "Lisbon")
        }

        $searchQuery
            .dropFirst(1)
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // Debounces the string publisher, such that it delays the process of sending request to remote server.
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {

                    self.state = .content(Array(self.allCities).sorted(by: { $0.name > $1.name }))
                    return nil
                }

                return string
            }) // Prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // Removes the nil values so the search string does not get passed down to the publisher chain
            .sink { _ in } receiveValue: { [self] (query) in

                Task {

                    await self.getCities(query: query)
                }
            }.store(in: &subscription)
    }

    // MARK: - Functions
    func getCities(query: String) async {

        do {

            let cities = try await apiService.getCity(cityName: query)

            DispatchQueue.main.async {

                self.allCities.formUnion(cities)
                self.state = .content(cities)
            }
        } catch {

            DispatchQueue.main.async {

                switch error as? ServiceError {

                case .noToken:
                    self.state = .error("No API token found. Please go to Settings and insert one.")
                case .invalidUrl:
                    self.state = .error("An invalid request has been attempted. Please contact support.")
                default:
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
}
