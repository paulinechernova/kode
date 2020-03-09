//
//  UIColor + extension.swift
//  CityWeather
//
//  Created by Admin on 24/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let darkBackgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1.0)
    static let lightBackgroundColor = UIColor(red: 1.0 - 0.118, green: 1.0 - 0.118, blue: 1.0 - 0.118, alpha: 1.0)
    
    static let dynamicBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return darkBackgroundColor
        } else {
            return lightBackgroundColor
        }
    }
}
