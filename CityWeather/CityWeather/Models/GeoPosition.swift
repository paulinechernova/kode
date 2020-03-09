//
//  GeoPosition.swift
//  CityWeather
//
//  Created by Admin on 04/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import Foundation

class GeoPosition: NSObject, NSCoding {
    
    var lon : Double
    var lat: Double
    
    func encode(with coder: NSCoder) {
        coder.encode(lon, forKey: "lon")
        coder.encode(lat, forKey: "lat")
    }
    
    required init?(coder: NSCoder) {
        lon = coder.decodeObject(forKey: "lon") as! Double
        lat = coder.decodeObject(forKey: "lat") as! Double
    }
    
    required init( Lon : Double, Lat: Double) {
        lon = Lon
        lat = Lat
       }

}
