//
//  ViewController.swift
//  CityWeather
//
//  Created by Admin on 17/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit
var foundCities : [City] = []
var selectedCity : Int = 0
class ViewController: UIViewController {

    private var lastSearchCities : [String] = []
    
    private var searchBarIsEmpty: Bool{
        guard let text = searchBar.text
            else {
                return false
        }
        return text.isEmpty
    }
    
    @IBOutlet var cityTableView: UITableView!{
       didSet{
            cityTableView.delegate = self
            cityTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.dynamicBackgroundColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        addTapGestureToHideKeyboard()
        super.viewDidLoad()
    }
}


extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        getNewCities(city: searchBar.text!)
        cityTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getNewCities(city: searchBar.text!)
        cityTableView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate{

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.text = ""
        cityTableView.reloadData()
    }

}

extension ViewController : UITableViewDataSource{
    private func tableView(tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        if !searchBarIsEmpty{
            selectedCity = indexPath.row
            self.performSegue(withIdentifier: "ShowWeatherInfo", sender: self)
        }
        else {
            searchBar.text = lastSearchCities[indexPath.row]
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBarIsEmpty {
            return foundCities.count
        }
        return lastSearchCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        if !searchBarIsEmpty {
            cell.cityLabel.text = foundCities[indexPath.row].LocalizedName
            cell.countryLabel.text = foundCities[indexPath.row].AdministrativeArea.LocalizedName+", "+foundCities[indexPath.row].Country.LocalizedName
        }
        else { cell.cityLabel.text = lastSearchCities[indexPath.row]
            cell.countryLabel.text = ""
        }
        return cell
    }


}

extension ViewController : UITableViewDelegate {}

struct City: Decodable {
    let Key : String
    let LocalizedName : String
    let Country : Country
    let AdministrativeArea : AdministrativeArea
}
struct Country : Decodable {
  let LocalizedName : String
}
struct AdministrativeArea : Decodable {
    let LocalizedName : String
}

extension ViewController {
    private func getNewCities(city: String){
        let configuration = URLSessionConfiguration.default
        let session = URLSession( configuration: configuration)
        let accessKey = "txOJDOLABbTlfqMKOcPpy7kkgLs020QC"
        let url = URL( string: "http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey="+accessKey+"&q="+city)!

       let task = session.dataTask(with: url){ [weak self] data, response, error in
            if let response = response {
                print("FSE")
            }
            guard
                let self = self,
                let result = try? JSONDecoder().decode([City].self, from: data!)
                else {
                   print("error")
                    return
                }
            print("Success getting data")
            foundCities = result
        }
            task.resume()
        }
    }

extension ViewController{
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

    private func updateLastCities(city: String){
        if lastSearchCities.contains(city){
            lastSearchCities.removeAll{$0 == city}
        }
        else {
            if lastSearchCities.count > 0 {
                lastSearchCities.removeLast()
            }
        }
        lastSearchCities.insert(city, at: 0)
    }
}


