//
//  Weather.swift
//  CityWeather
//
//  Created by Admin on 04/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import Foundation

class Weather: NSObject, NSCoding {
    
    var desc : String
    var time : String
    var color : String
    
    func encode(with coder: NSCoder) {
        coder.encode(desc, forKey: "desc")
        coder.encode(time, forKey: "time")
        coder.encode(color, forKey: "color")
    }
    
    required init?(coder: NSCoder) {
        desc  = coder.decodeObject(forKey: "desc") as! String
        time = coder.decodeObject(forKey: "time") as! String
        color = coder.decodeObject(forKey: "color") as! String
    }
    
    required init(Desc:String, Time: String, Color: String) {
        desc  = Desc
        time = Time
        color = Color
       }

}
