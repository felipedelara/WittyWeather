//
//  CoreCity+CoreDataProperties.swift
//  WittyWeather
//
//  Created by Felipe Lara on 12/09/2023.
//
//

import Foundation
import CoreData


extension CoreCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreCity> {
        return NSFetchRequest<CoreCity>(entityName: "CoreCity")
    }

    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

}

extension CoreCity : Identifiable {

}
