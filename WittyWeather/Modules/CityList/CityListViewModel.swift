//
//  CityListViewModel.swift
//  WittyWeather
//
//  Created by Felipe Lara on 09/09/2023.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class CityListViewModel: ObservableObject {

    enum ViewState {

        case loading
        case content([City])
        case error(String)
    }

    // MARK: Private properties
    private var allCities: Set<City> = [] // Sets will avoid duplicates
    private var apiService: APIServiceType
    private var subscription: Set<AnyCancellable> = []
    private (set) var managedObjectContext: NSManagedObjectContext

    // MARK: Published properties
    @Published var state: ViewState = .loading
    @Published var searchQuery: String = String()

    // MARK: Lifecycle
    init(apiService: APIServiceType = APIService(),
         managedObjectContext: NSManagedObjectContext) {

        self.apiService = apiService
        self.managedObjectContext = managedObjectContext
        self.state = .loading

        self.loadCities()

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

                    await self.getMoreCities(query: query)
                }
            }.store(in: &subscription)
    }

    // MARK: - Public functions
    func getMoreCities(query: String) async {

        do {

            let cities = try await apiService.getCity(cityName: query)

            self.saveLocalCities(cities)

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

// MARK: - Private functions
private extension CityListViewModel {

    func loadCities() {

        let fetchRequest: NSFetchRequest<CoreCity> = CoreCity.fetchRequest()

        do {

            let coreCities = try managedObjectContext.fetch(fetchRequest)

            var normalCities = [City]()

            for coreCity in coreCities {

                guard let name = coreCity.name, let country = coreCity.country, let state = coreCity.state else {

                    continue
                }

                normalCities.append(City(name: name,
                                         localNames: nil,
                                         lat: coreCity.lat,
                                         lon: coreCity.lon,
                                         country: country,
                                         state: state))
            }

            if normalCities.isEmpty {

                // Fallback to listing default city
                Task {

                    await self.getMoreCities(query: "Lisbon")
                }

            } else {

                self.allCities.formUnion(normalCities)
                self.state = .content(normalCities)
            }

        } catch {

            // Fallback to listing default city
            Task {

                await self.getMoreCities(query: "Lisbon")
            }
        }
    }

    func saveLocalCities(_ cities: [City]) {

        for city in cities {

            let coreCity = CoreCity(context: self.managedObjectContext)
            coreCity.name = city.name
            coreCity.lon = city.lon
            coreCity.lat = city.lat
            coreCity.country = city.country
            coreCity.state = city.state
        }

        try? self.managedObjectContext.save()
    }
}
