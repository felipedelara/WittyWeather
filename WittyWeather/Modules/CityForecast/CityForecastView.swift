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

    @StateObject var viewModel = ForecastListViewModel()

    var body: some View {

        NavigationView {

            switch viewModel.state {

            case .loading:
                ProgressView("Loading...")

            case .content(let groupedForecasts):

                List {

                    ForEach(groupedForecasts, id: \.0) { day, dayForecasts in

                        Section(header: Text(day)) {

                            ForEach(dayForecasts, id: \.dt) { forecast in

                                HStack {

                                    Text(forecast.hour)
                                        .font(.headline)


                                    VStack(alignment: .leading) {

                                        Text(forecast.description).font(.subheadline)

                                        Text("Temp. \(forecast.currentTemperatureCelsius)").font(.subheadline)
                                        Text("Max. \(forecast.maxTemperatureCelsius)").font(.subheadline)
                                        Text("Min. \(forecast.minTemperatureCelsius)").font(.subheadline)
                                    }
                                    Spacer()
                                    IconView(viewModel: IconViewModel(iconDesc: forecast.icon))
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

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
        }.navigationBarTitle("\(city.name)'s 5 day forecast")
    }
    
}

struct ForecastListView_Previews: PreviewProvider {

    static var previews: some View {

        let sampleCity = City(name: "New York", localNames: ["en": "New York"], lat: 40.7128, lon: -74.0060, country: "US", state: "NY")

        return CityForecastView(city: sampleCity)
    }
}
