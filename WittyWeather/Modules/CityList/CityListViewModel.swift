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

    private (set) var managedObjectContext: NSManagedObjectContext

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

    init(apiService: APIServiceType = APIService(),
         managedObjectContext: NSManagedObjectContext) {

        self.apiService = apiService

        self.managedObjectContext = managedObjectContext

        self.state = .loading

        self.getLocalCities()

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

    func getLocalCities() {

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

                Task {

                    await self.getCities(query: "Lisbon")
                }

            } else {

                self.allCities.formUnion(normalCities)
                self.state = .content(normalCities)
            }

        } catch {

            // Fallback to getting one demo city
            Task {

                await self.getCities(query: "Lisbon")
            }
        }
    }

    // MARK: - Functions
    func getCities(query: String) async {

        do {

            let cities = try await apiService.getCity(cityName: query)

            for city in cities {

                let coreCity = CoreCity(context: managedObjectContext)
                coreCity.name = city.name
                coreCity.lon = city.lon
                coreCity.lat = city.lat
                coreCity.country = city.country
                coreCity.state = city.state
            }

            try? managedObjectContext.save()

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
