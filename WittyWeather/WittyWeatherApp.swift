//
//  WittyWeatherApp.swift
//  WittyWeather
//
//  Created by Felipe Lara on 07/09/2023.
//

import SwiftUI

@main
struct WittyWeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {

            CityListView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
