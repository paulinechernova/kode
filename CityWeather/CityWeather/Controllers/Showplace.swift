//
//  Showplace.swift
//  CityWeather
//
//  Created by Admin on 27/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit

struct Geo {
    var Latitude: Double
    var Longitude: Double
}

struct Showplace {
    var name : String
    var imageName : String
    var decs : String
    var fulldesc : String
    var geo : Geo
}

var MoscowList : [Showplace] = [Showplace(name: "Красная площадь", imageName: "redSq.jpg", decs: "главная площадь Москвы, расположена между Московским Кремлём и Китай-городом.", fulldesc: "С момента своего формирования Красная площадь сменила несколько названий. Первое летописное упоминание о ней относится к XV веку и находится в записи 1434 года о смерти юродивого Максима, «который положен бысть у Бориса и Глеба на Варварьской улице за Торгом». Торгом нынешняя Красная площадь называлась вплоть до начала XVII века, хотя существовала не только как рынок, но и как центр общественной жизни: например, на ней проходили «побивания кнутом» и казни.", geo: Geo(Latitude: 55.75268, Longitude: 37.61844) ) ]

var showplaceList : Dictionary<String, [Showplace]> = ["294021": MoscowList]
