//
//  City.swift
//  CityWeather
//
//  Created by Admin on 04/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import Foundation

class City: NSObject, NSCoding {
    
    var key : String
    var cityName : String
    var country : String
    
    func encode(with coder: NSCoder) {
        coder.encode(key, forKey: "key")
        coder.encode(cityName, forKey: "cityName")
        coder.encode(country, forKey: "country")
    }
    
    required init?(coder: NSCoder) {
        key = coder.decodeObject(forKey: "key") as! String
        cityName = coder.decodeObject(forKey: "cityName") as! String
        country = coder.decodeObject(forKey: "country") as! String
    }
    
    required init(Key:String, CityName: String, Country: String) {
        key = Key
        cityName = CityName
        country = Country
       }

}
