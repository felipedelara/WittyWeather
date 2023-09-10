//
//  CityItemView.swift
//  WittyWeather
//
//  Created by Felipe Lara on 09/09/2023.
//

import Foundation
import SwiftUI
import MapKit

struct CityListItem: View {

    let city: City

    var body: some View {

        NavigationLink(destination: ForecastListView(city: city)) {

            HStack {

                Text(city.name)
                    .font(.headline)

                if let state = city.state {
                    Text(state)
                        .font(.subheadline)
                }

                Spacer()

                Text(StringContants.countryEmojiFlags[city.country] ?? "")
                    .font(.headline)
            }
        }
    }
}

struct CityListItem_Previews: PreviewProvider {

    static var previews: some View {

        let sampleCity = City(name: "New York", localNames: ["en": "New York"], lat: 40.7128, lon: -74.0060, country: "US", state: "NY")
        return CityListItem(city: sampleCity)
    }
}
