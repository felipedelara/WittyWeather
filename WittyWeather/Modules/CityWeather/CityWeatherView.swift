//
//  CityWeatherView.swift
//  WittyWeather
//
//  Created by Felipe Lara on 10/09/2023.
//

import Foundation
import SwiftUI

struct CityForecastView: View {

    let city: City

    @StateObject var viewModel = CityForecastViewModel()

    var body: some View {

        NavigationView {

            switch viewModel.state {

            case .loading:
                ProgressView("Loading...")

            case .content(let forecasts):

                List(forecasts, id: \.self) { forecast in

                    VStack(alignment: .leading) {

                        Text(forecast.dtTxt)
                        Text("Temp. \(forecast.main.temp)")
                        Text("Max. \(forecast.main.tempMax)")
                        Text("Min. \(forecast.main.tempMin)")

                    }
                }
            case .error(let errorMessage):
                //TODO: revisit this
                VStack {
                    Text("Error: \(errorMessage)")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()

                    Button("Try again") {
                        Task {
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 40.0)
                    .buttonStyle(PrimaryButtonStyle())

                }
            }
        }.onAppear {

            Task {

                await viewModel.getForecast(city: self.city)
            }
        }
    }
}

struct ForecastListView_Previews: PreviewProvider {

    static var previews: some View {

        let sampleCity = City(name: "New York", localNames: ["en": "New York"], lat: 40.7128, lon: -74.0060, country: "US", state: "NY")

        return CityForecastView(city: sampleCity)
    }
}

class CityForecastViewModel: ObservableObject {

    enum ViewState {

        case loading
        case content([Forecast])
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

            let forecast = try await self.apiService.getForecast(city:city)

            DispatchQueue.main.async {

                self.state = .content(forecast.list)
            }

        } catch {

            print(error)
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
