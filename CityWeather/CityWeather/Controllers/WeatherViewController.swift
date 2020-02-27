//
//  WeatherViewController.swift
//  CityWeather
//
//  Created by dv on 22/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController{
    var forecast: Forecast!
    @IBOutlet weak var weatherCollectionView: UICollectionView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var PlaceButton: UIButton!{
        didSet{
            try?{
                 if showplaceList[(foundCities[selectedCity]).Key] == nil  {
                     self.PlaceButton.isHidden = true
                 }
            }
        }
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.dynamicBackgroundColor
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        super.viewDidLoad()
        try? {
            self.getWeatherInfo(cityKey: foundCities[selectedCity].Key)
        }
    }
}
extension WeatherViewController : UICollectionViewDelegate {}
extension WeatherViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        if indexPath.section == 0 {
            cell.timeLabel.text =  "0.0" //(indexPath.row * 3 as String ) + ".00"
            //cell.descLabel.text = forecast.list[indexPath.row].weather[0].description
        } else {
            cell.timeLabel.text =  "0.0" //(indexPath.row * 3 as String ) + ".00"
            //cell.descLabel.text = forecast.list[indexPath.row + 8].weather[0].description
        }
        
        return cell
    }
}

struct Response: Decodable {
    let GeoPosition : GeoPosition
}

struct GeoPosition: Decodable {
    let Latitude: String
    let Longitude: String
}

struct Forecast : Decodable {
    let list: [Weather]
}

struct Weather : Decodable {
    let weather : [WeatherDescription]

}

class WeatherDescription : Decodable {
    let description : String
}


extension WeatherViewController{
    private func getCityCoordinates(cityKey: String) -> GeoPosition{
        var Geo : GeoPosition!
        let configuration = URLSessionConfiguration.default
        let session = URLSession( configuration: configuration)
        let accessKey = "txOJDOLABbTlfqMKOcPpy7kkgLs020QC"
        let url = URL( string: "http://dataservice.accuweather.com/locations/v1/"+cityKey+"?apikey="+accessKey)!
        let task = session.dataTask(with: url){ [weak self] data, response, error in
             guard
                 let self = self,
                 let result = try? JSONDecoder().decode(Response.self, from: data!)
                 else {
                    print("error")
                     return
                 }
             print("Success getting coordinates")
            Geo = result.GeoPosition
            print(Geo! as Any)
         }
             task.resume()
        return Geo
        }

   private  func getWeatherInfo( cityKey: String){
    let coordinates = getCityCoordinates(cityKey: cityKey)
        let configuration = URLSessionConfiguration.default
        let session = URLSession( configuration: configuration)
        let accessKey = "76b49828a370fb52c8b2f1df3194bdcb"
        //let url = URL( string: "http://api.openweathermap.org/data/2.5/forecast?lat="+"54.54"+"&lon="+"39"+"&appid="+accessKey)!
    let url = URL( string: "http://api.openweathermap.org/data/2.5/forecast?lat="+coordinates.Latitude+"&lon="+coordinates.Longitude+"&appid="+accessKey)!
    let task = session.dataTask(with: url){ [weak self] data, response, error in
            guard
                let self = self,
                let result = try? JSONDecoder().decode(Forecast.self, from: data!)
                else {
                   print("error")
                    return
                }
        self.forecast = result
    }
        print("Success getting forecast")
    task.resume()
    }
}
