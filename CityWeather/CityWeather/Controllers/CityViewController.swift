//
//  CityViewController.swift
//  CityWeather
//
//  Created by Admin on 26/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit
import MapKit

class CityViewController : ViewController {
    private var footer = UIView()
    private var currentCity : City!
    private var coordinates = GeoPosition( Lon: 0.0, Lat: 0.0)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mapView =  MKMapView()
    private var nameLabel = UILabel()
    private var todayDateLabel = UILabel()
    private var todayWeatherData : [Weather] = [ ]
    private var tomorrowWeatherData : [Weather] = []
    private var todayWeatherCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 120)
        layout.scrollDirection = .horizontal
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colView.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
        colView.showsHorizontalScrollIndicator = false
        return colView
    }()
    private var tomorrowWeatherCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 120)
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        colView.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
        colView.showsHorizontalScrollIndicator = false
        return colView
    }()
    private var tomorrowDateLabel = UILabel()
    
     private var showplaceButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.layer.cornerRadius = 12
        button.setTitle("Достопримечательности", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        return button
    }()
        
    
    override func viewDidLoad() {
        setUp()
        prepareData()
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode(rawValue: 2)!
        super.viewDidLoad()
        navigationItem.searchController = nil
        navigationItem.rightBarButtonItem = nil
        footer = addFooter()
        configureScrollView()
    }
    
    @objc func action(_ sender : UIButton){
        let newViewController = ShowplaceTableViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }

    func prepareData(){
        let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.lastSearchCities) as! Data
        let allLastCities = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [City]
        currentCity = allLastCities[0]
        getCityCoordinates(cityKey: currentCity.key)
        getWeatherInfo()
    }
    
    private func configureScrollView(){
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: footer.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        
        contentView.anchor(top: scrollView.topAnchor, left: nil, bottom: scrollView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        configureContentView()
    }
    
    private func configureContentView(){
        configureMap(cityKey: currentCity.key )
        configureNameLabel(cityName : currentCity.cityName)
        configureTodayDateLabel()
        configureTodayWeatherCollectionView()
        configureTomorrowDateLabel()
        configureTomorrowWeatherCollectionView()
        let allplaces = fetchPlaces(cityKey: currentCity.key)
        if allplaces.count > 0 {
             configureShowplaceButton()
        }
    }
    
    private func configureMap(cityKey: String){
        mapView.register(MapMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        contentView.addSubview(mapView)
        mapView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor , bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 250, enableInsets: false)
       }
    private func configureMapMarker(){
        let location = CLLocation(latitude: Double(coordinates.lat), longitude: Double(coordinates.lon) )
        let regionRadius: CLLocationDistance = 1500
        let annotation = MKPointAnnotation()
        annotation.coordinate =  CLLocationCoordinate2D( latitude: Double(coordinates.lat) , longitude: Double(coordinates.lon))
        mapView.addAnnotation(annotation)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    private func configureNameLabel(cityName : String){
        nameLabel.text = cityName
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: mapView.bottomAnchor, left: contentView.leftAnchor , bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0, enableInsets: false)
    }
    
    private func configureTodayDateLabel(){
        todayDateLabel.text = "Сегодня"
        todayDateLabel.textAlignment = .left
        todayDateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        todayDateLabel.textColor = .darkGray
        contentView.addSubview(todayDateLabel)
        todayDateLabel.anchor(top: nameLabel.bottomAnchor, left: contentView.leftAnchor , bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0 , paddingRight: 20, width: 0, height: 0, enableInsets: false)
    }
    private func configureTodayWeatherCollectionView(){
        todayWeatherCollectionView.backgroundColor = UIColor.clear
        contentView.addSubview(todayWeatherCollectionView)
        todayWeatherCollectionView.anchor(top: todayDateLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 3, paddingBottom: 0, paddingRight: 3, width: 0, height: 120, enableInsets: false)
        todayWeatherCollectionView.delegate = self
        todayWeatherCollectionView.dataSource = self
    }
    
     private func configureTomorrowDateLabel(){
           tomorrowDateLabel.text = "Завтра"
           tomorrowDateLabel.textAlignment = .left
           tomorrowDateLabel.font = UIFont.boldSystemFont(ofSize: 15)
           tomorrowDateLabel.textColor = .darkGray
           contentView.addSubview(tomorrowDateLabel)
           tomorrowDateLabel.anchor(top: todayWeatherCollectionView.bottomAnchor, left: contentView.leftAnchor , bottom: nil, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 0 , paddingRight: 20, width: 0, height: 0, enableInsets: false)
       }
    
    private func configureTomorrowWeatherCollectionView(){
        tomorrowWeatherCollectionView.backgroundColor = UIColor.clear
        contentView.addSubview(tomorrowWeatherCollectionView)
        tomorrowWeatherCollectionView.anchor(top: tomorrowDateLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 3, paddingBottom: 0, paddingRight: 3, width: 0, height: 120, enableInsets: false)
        tomorrowWeatherCollectionView.delegate = self
        tomorrowWeatherCollectionView.dataSource = self
    }
    private func configureShowplaceButton(){
        contentView.addSubview(showplaceButton)
        showplaceButton.anchor(top: tomorrowWeatherCollectionView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 60, enableInsets: false)
    }
}

extension CityViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case todayWeatherCollectionView :
            return todayWeatherData.count
        case tomorrowWeatherCollectionView:
            return tomorrowWeatherData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        switch collectionView {
        case todayWeatherCollectionView :
            let todayCell = todayWeatherData[indexPath.row]
            cell.weather = todayCell
        case tomorrowWeatherCollectionView:
            let tomorrowCell = tomorrowWeatherData[indexPath.row]
           cell.weather = tomorrowCell
        default:
            return UICollectionViewCell()
        }
        return cell
    }
}
extension CityViewController : UICollectionViewDelegate{}


extension CityViewController {
    private func getWeatherInfo() {
        var wasGettingToday : Bool = false
        var today : String = ""
        let lonStr : String = String(coordinates.lon)
        let latStr : String = String(coordinates.lat)
        let configuration = URLSessionConfiguration.default
        let session = URLSession( configuration: configuration)
        let url = URL( string: "http://samples.openweathermap.org/data/2.5/forecast/hourly?lat="+latStr+"&lon="+lonStr+"&appid=b6907d289e10d714a6e88b30761fae22")!
        let task = session.dataTask(with: url){  data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, Any>
            let list = json!["list"] as! [[String: Any]]
            for data: [String: Any] in list {
                let detail = data["weather"] as! [NSDictionary]
                let pic = detail[0].value(forKey: "icon") as!  String
                let words = detail[0].value(forKey: "description")  as!  String
                let date = data["dt_txt"]  as!  String
                let parts = date.split(separator: " ")
                let yearMonthDay = parts[0].split(separator: "-")
                if !wasGettingToday {
                    wasGettingToday = true
                    today = String ( yearMonthDay[2] )
                }
                let time = parts[1].split(separator: ":")
                if today == yearMonthDay[2] {
                    self.todayWeatherData.append( Weather(Desc: words , Time: String(time[0]+":"+time[1]), Color: pic) )
                }
                else if Int(today)! + 1 == Int(yearMonthDay[2]) {
                    self.tomorrowWeatherData.append( Weather(Desc: words , Time: String(time[0]+":"+time[1]), Color: pic) )
                }
            }
            
            DispatchQueue.main.async {
                self.todayWeatherCollectionView.reloadData()
                self.tomorrowWeatherCollectionView.reloadData()
            }
        }
        task.resume()
    }
    
    private func getCityCoordinates(cityKey: String) {
        var lon : Double = 0.0
        var lat : Double = 0.0
        let configuration = URLSessionConfiguration.default
        let session = URLSession( configuration: configuration)
        //let accessKey = "qUWACSMA8XxxEni8UkYHGjZBPG9WTkKy"
       //let accessKey = "lrjGSI59G857CNkVurOqm7W2FngsGRGW"
         let accessKey = "txOJDOLABbTlfqMKOcPpy7kkgLs020QC"
         let url = URL( string: "http://dataservice.accuweather.com/locations/v1/"+cityKey+"?apikey="+accessKey)!
         let task = session.dataTask(with: url){  data, response, error in
             if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                if let geo = json["GeoPosition"] as? [String : Any] {
                     lon  = (geo["Longitude"] as! NSNumber).doubleValue
                     lat = (geo["Latitude"] as! NSNumber).doubleValue
                }
                self.coordinates = GeoPosition(Lon: lon, Lat: lat)
                DispatchQueue.main.async {
                    self.configureMapMarker()
                }
         }
     }
         task.resume()
    }
}

