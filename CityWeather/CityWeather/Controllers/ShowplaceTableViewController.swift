//
//  ShowplaceTableViewController.swift
//  CityWeather
//
//  Created by Admin on 26/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//


import UIKit
import CoreData

class ShowplaceTableViewController: UIViewController {
    let defaults = UserDefaults.standard
    var places :  [NSManagedObject] = []
    let showplaceTableView = UITableView.init( frame: CGRect.zero)
    
    override func viewDidLoad() {
        setUp()
        getPlaces()
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode(rawValue: 2)!
        navigationItem.title = "Достопримечательности"
        navigationItem.rightBarButtonItem = nil
        super.viewDidLoad()
        configureTableView()
        self.updateLayout( with: self.view.frame.size )
    }
    
     override func viewWillTransition( to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator ){
        super.viewWillTransition(to : size, with : coordinator)
        coordinator.animate( alongsideTransition: { (context) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    private func updateLayout(with size: CGSize){
        self.showplaceTableView.frame = CGRect.init( origin : .zero, size : size )
    }
}

extension ShowplaceTableViewController {
    private func configureTableView(){
        self.view.addSubview( self.showplaceTableView)
        self.showplaceTableView.register(ShowplaceCell.self, forCellReuseIdentifier: "ShowplaceCell")
        self.showplaceTableView.delegate = self
        self.showplaceTableView.dataSource = self
        self.showplaceTableView.separatorStyle = UITableViewCell.SeparatorStyle(rawValue: 0)!
        showplaceTableView.backgroundColor = .clear
    }
}

extension ShowplaceTableViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place =  places[indexPath.row]
        let name = place.value(forKey: "name") as! String
        let imgUrl = place.value(forKey: "imageURL") as! String
        let desc = place.value(forKey: "desc") as! String
        let descfull = place.value(forKey: "descfull") as! String
        let geo = place.value(forKey: "geo") as! NSManagedObject

        let lon : Double = geo.value(forKey: "lon") as! Double
        let lat : Double = geo.value(forKey: "lat") as! Double
        let currentPlace : CurrentPlace = CurrentPlace(Name: name , ImageURL: imgUrl , Desc: desc, Descfull: descfull, Lon: lon, Lat: lat)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: currentPlace)
        defaults.set(encodedData, forKey: UserDefaultKeys.currentPlace )
        let newViewController = ShowplaceViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 280
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showplaceTableView.dequeueReusableCell(withIdentifier: "ShowplaceCell", for: indexPath) as! ShowplaceCell
        cell.backgroundColor = .clear
        let place = places[indexPath.row]
        cell.nameLabel.text = place.value(forKey: "name") as? String
        cell.descLabel.text = place.value(forKey: "desc") as? String
        let url = place.value(forKey: "imageURL") as? String
        cell.showplaceImageView.loadImage(url: url ?? "")
        return cell
    }
}

extension ShowplaceTableViewController : UITableViewDelegate {}

extension ShowplaceTableViewController {
    
    func getPlaces() {
        let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.lastSearchCities) as! Data
        let allLastCities = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [City]
        let key  =  allLastCities[0].key
        let allPlaces = fetchPlaces(cityKey: key)
        places =  (allPlaces.allObjects as NSArray) as! [NSManagedObject]
        DispatchQueue.main.async {
             self.showplaceTableView.reloadData()
        }
    }
}
