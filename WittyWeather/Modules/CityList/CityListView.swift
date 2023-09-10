//
//  CityListView.swift
//  WittyWeather
//
//  Created by Felipe Lara on 09/09/2023.
//

import Foundation
import SwiftUI

struct CityListView: View {

    @StateObject private var viewModel = CityListViewModel()

    var body: some View {
        NavigationView {

            switch viewModel.state {

            case .loading:
                ProgressView("Loading...")

            case .content(let cities):

                List(cities, id: \.self) { city in
                    CityListItem(city: city)
                }.searchable(text: $viewModel.searchQuery)

            case .error(let errorMessage):
                //TODO: revisit this
                VStack {
                    Text("Error: \(errorMessage)")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()

                    Button("Try again") {

                        Task {
                            await viewModel.getCities(query: (viewModel.searchQuery.isEmpty ? "Lisbon" : viewModel.searchQuery))
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 40.0)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {

    static var previews: some View {

        CityListView()
    }
}
