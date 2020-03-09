//
//  CoreCity+CoreDataProperties.swift
//  CityWeather
//
//  Created by Admin on 09/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreCity> {
        return NSFetchRequest<CoreCity>(entityName: "CoreCity")
    }

    @NSManaged public var key: String?
    @NSManaged public var name: String?
    @NSManaged public var place: NSSet?

}

// MARK: Generated accessors for place
extension CoreCity {

    @objc(addPlaceObject:)
    @NSManaged public func addToPlace(_ value: Place)

    @objc(removePlaceObject:)
    @NSManaged public func removeFromPlace(_ value: Place)

    @objc(addPlace:)
    @NSManaged public func addToPlace(_ values: NSSet)

    @objc(removePlace:)
    @NSManaged public func removeFromPlace(_ values: NSSet)

}
