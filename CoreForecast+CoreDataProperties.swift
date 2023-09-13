//
//  CoreForecast+CoreDataProperties.swift
//  WittyWeather
//
//  Created by Felipe Lara on 14/09/2023.
//
//

import Foundation
import CoreData


extension CoreForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreForecast> {
        return NSFetchRequest<CoreForecast>(entityName: "CoreForecast")
    }

    @NSManaged public var day: String?
    @NSManaged public var hour: String?
    @NSManaged public var icon: String?
    @NSManaged public var currentTemp: String?
    @NSManaged public var feelsLike: String?
    @NSManaged public var dt: Int64
    @NSManaged public var cityHash: Int64

}

extension CoreForecast : Identifiable {

}
