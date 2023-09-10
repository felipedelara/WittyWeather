//
//  ForecastListView.swift
//  WittyWeather
//
//  Created by Felipe Lara on 10/09/2023.
//

import Foundation
import SwiftUI

struct CityForecastItemView: View {

    let forecast: ForecastViewModel

    var body: some View{

        HStack {

            Text(forecast.hour)
                .font(.headline)


            VStack(alignment: .leading) {

                Text("Temp. \(forecast.currentTemperatureCelsius)").font(.subheadline)
                Text("Feels like \(forecast.feelsLike)").font(.subheadline)
            }
            Spacer()
            IconView(viewModel: IconViewModel(iconDesc: forecast.icon))
        }
    }
}

struct ForecastListView: View {

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

                                CityForecastItemView(forecast: forecast)
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
        }.navigationBarTitle("\(city.name)'s forecast")
    }
    
}

struct ForecastListView_Previews: PreviewProvider {

    static var previews: some View {

        let sampleCity = City(name: "New York", localNames: ["en": "New York"], lat: 40.7128, lon: -74.0060, country: "US", state: "NY")

        return ForecastListView(city: sampleCity)
    }
}
