//
//  UIImage + extension.swift
//  CityWeather
//
//  Created by Admin on 04/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func loadImage(url : String){
        DispatchQueue.main.async {
            if let Url = URL( string: url) {
                    if let data = try? Data(contentsOf: Url) {
                        self.image = UIImage(data : data)
                    } else { self.image = UIImage(systemName: "multiply")}
                } else {
                    self.image = UIImage( systemName: "multiply")
                }
            }
        }
}
