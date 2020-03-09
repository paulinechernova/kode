//
//  String + extension.swift
//  CityWeather
//
//  Created by Admin on 28/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit
extension String{
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String {
        return self.removingPercentEncoding!
    }
    var containsCyrillic : Bool {
        for chr in self {
           if ((chr >= "а" && chr <= "я") || (chr >= "А" && chr <= "Я") ) {
              return true
           }
        }
        return false
    }
    var invalid : Bool {
        let space : Character = " "
        let defice : Character = "-"
        for chr in self {
           if (!(chr >= "а" && chr <= "я") && !(chr >= "А" && chr <= "Я")  && !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && chr != space && chr != defice) {
              return true
           }
        }
        return false
    }}
