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

            case .content(let groupedForecasts):

                List {

                    ForEach(groupedForecasts, id: \.0) { day, dayForecasts in

                        Section(header: Text(day)) {

                            ForEach(dayForecasts, id: \.dt) { forecast in

                                VStack(alignment: .leading) {
                                    Text(forecast.dtTxt.hourFromDate())
                                    Text("Temp. \(forecast.main.temp)")
                                    Text("Max. \(forecast.main.tempMax)")
                                    Text("Min. \(forecast.main.tempMin)")
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
        }
    }
    
}

struct ForecastListView_Previews: PreviewProvider {

    static var previews: some View {

        let sampleCity = City(name: "New York", localNames: ["en": "New York"], lat: 40.7128, lon: -74.0060, country: "US", state: "NY")

        return CityForecastView(city: sampleCity)
    }
}
