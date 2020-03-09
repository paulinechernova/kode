//
//  CityCell.swift
//  CityWeather
//
//  Created by Admin on 26/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit


class CityCell : UITableViewCell, UITableViewDelegate {
    //var delegate
    var city : City? {
        didSet{
            cityLabel.text = city?.cityName
            countryLabel.text = city?.country
        }
    }
    
    private let cityLabel : UILabel = {
        let citylabel = UILabel()
        citylabel.font = UIFont(name: "Arial-BoldMT", size: 30)
        //citylabel.font = UIFont(name: "SFProText-Heavy", size: 32)
        citylabel.textAlignment = .left
    return citylabel
    }()
    
    private let countryLabel : UILabel = {
    let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
    return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cityLabel)
        addSubview(countryLabel)

        cityLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0, enableInsets: false)
        countryLabel.anchor(top: cityLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 1, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0, enableInsets: false)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    
}

