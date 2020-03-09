//
//  Place+CoreDataProperties.swift
//  CityWeather
//
//  Created by Admin on 09/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var desc: String?
    @NSManaged public var descfull: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var corecity: CoreCity?
    @NSManaged public var geo: Geo?

}
