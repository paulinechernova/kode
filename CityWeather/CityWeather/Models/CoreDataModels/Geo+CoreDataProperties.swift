//
//  Geo+CoreDataProperties.swift
//  CityWeather
//
//  Created by Admin on 09/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//
//

import Foundation
import CoreData


extension Geo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Geo> {
        return NSFetchRequest<Geo>(entityName: "Geo")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var place: Place?

}
