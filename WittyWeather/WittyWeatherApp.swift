//
//  WittyWeatherApp.swift
//  WittyWeather
//
//  Created by Felipe Lara on 07/09/2023.
//

import SwiftUI
import CoreData

@main
struct WittyWeatherApp: App {

    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {

            CityListView(viewModel: CityListViewModel(managedObjectContext: dataController.persistentContainer.viewContext))
                .environment(\.managedObjectContext, dataController.persistentContainer.viewContext)
        }
    }
}
