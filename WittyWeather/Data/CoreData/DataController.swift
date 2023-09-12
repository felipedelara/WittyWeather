//
//  DataController.swift
//  WittyWeather
//
//  Created by Felipe Lara on 12/09/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {

    init() {}

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "WittyWeather")

        container.loadPersistentStores { (storeDescription, error) in

            if let error {

                 fatalError("Core Data persistent store - Unresolved error \(error)")
            }
        }

        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save changes to the Core Data context
    func saveContext() {

        if viewContext.hasChanges {

            do {

                try viewContext.save()

            } catch {

                fatalError("Core Data persistent store - Unresolved error \(error)")
            }
        }
    }
}
