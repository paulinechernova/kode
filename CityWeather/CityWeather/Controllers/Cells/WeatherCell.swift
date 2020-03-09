//
//  WeatherCell.swift
//  CityWeather
//
//  Created by Admin on 01/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit

class WeatherCell : UICollectionViewCell {
    var weather : Weather? {
        didSet{
            descLabel.text =  getDesc(desc: weather?.desc ?? "")
            timeLabel.text =  weather?.time
            weatherImage.image = getImage(desc: descLabel.text ?? "ясно", icon: weather?.color ?? "n")
        }
    }
    
    private func getDesc(desc: String) -> String {
        switch desc {
            case "clear sky":
                return "ясно"
            case "few clouds", "scattered clouds", "broken clouds", "overcast clouds":
                   return "облачно"
            case "shower rain", "rain", "light rain":
                return "дождливо"
            default:
                return "туманно"
            }
    }
    
    private func getImage( desc : String, icon : String) -> UIImage {
        switch desc {
            case  "ясно" :
                if  icon.contains("n") {
                    return UIImage(systemName: "moon.fill")!
                } else {
                    return UIImage ( systemName: "sun.max.fill")! }
            case "облачно":
                return UIImage( systemName: "cloud.fill" )!
            case "дождливо":
                return UIImage ( systemName: "cloud.rain.fill")!
            default:
                return UIImage( systemName: "cloud.fog.fill")!
                   }
    }
    
    
    private let descLabel : UILabel = {
    let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
    return label
    }()
    
    private let timeLabel : UILabel = {
    let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
    return label
    }()
    
    private var weatherImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
       imgView.clipsToBounds = true
    return imgView
    }()
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.darkGray
        
        addSubview(weatherImage)
        addSubview(descLabel)
        addSubview(timeLabel)
        weatherImage.anchor(top: topAnchor, left: leftAnchor, bottom: descLabel.topAnchor, right: rightAnchor, paddingTop: 3, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        descLabel.anchor(top: nil, left: leftAnchor, bottom: timeLabel.topAnchor , right: rightAnchor, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 3, width: 0 , height: 0, enableInsets: false)
        timeLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 3, paddingBottom: 5, paddingRight: 3, width: 0,  height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    
}


