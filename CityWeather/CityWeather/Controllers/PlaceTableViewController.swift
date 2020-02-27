//
//  PlaceTableViewController.swift
//  CityWeather
//
//  Created by Admin on 27/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import Foundation

import UIKit

var selectedPlace : Int = 0
class PlaceTableViewController: UIViewController {
    
    @IBOutlet weak var placeTableView: UITableView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.dynamicBackgroundColor
        super.viewDidLoad()
    }

}

extension PlaceTableViewController : UITableViewDataSource{
    private func tableView(tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        selectedPlace = indexPath.row
        self.performSegue(withIdentifier: "ShowPlaceInfo", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showplaceList[(foundCities[selectedCity]).Key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as? PlaceCell {
            cell.nameLabel.text = showplaceList[(foundCities[selectedCity]).Key]?[indexPath.row].name
            cell.shortDescLabel.text = showplaceList[(foundCities[selectedCity]).Key]?[indexPath.row].decs
            //cell.mainImageView
            return cell
        }
        return UITableViewCell()
    }


}
