//
//  Place.swift
//  CityWeather
//
//  Created by Admin on 09/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import Foundation

class CurrentPlace: NSObject, NSCoding{
    
    var name : String
    var imageURL : String
    var desc : String
    var descfull : String
    var lon : Double?
    var lat : Double?
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(imageURL, forKey: "imageURL")
        coder.encode(desc, forKey: "desc")
        coder.encode(descfull, forKey: "descfull")
        coder.encode(lon, forKey: "lon")
        coder.encode(lat, forKey: "lat")
    }
    
    required init?(coder: NSCoder) {
        name  = coder.decodeObject(forKey: "name") as! String
        imageURL  = coder.decodeObject(forKey: "imageURL") as! String
        desc  = coder.decodeObject(forKey: "desc") as! String
        descfull = coder.decodeObject(forKey: "descfull") as! String
        lon   = coder.decodeObject(forKey: "lon") as? Double
        lat   = coder.decodeObject(forKey: "lat") as? Double
    }
    
    required init(Name : String, ImageURL : String, Desc : String, Descfull: String, Lon : Double?, Lat : Double?) {
        name = Name
        imageURL = ImageURL
        desc = Desc
        descfull = Descfull
        lon = Lon
        lat = Lat
       }
  
}
