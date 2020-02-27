//
//  PlaceInfoController.swift
//  CityWeather
//
//  Created by Admin on 25/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit
import MapKit

class PlaceInfoViewController: UIViewController{
    var selected = foundCities[selectedCity].Key
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            //imageView.image = UIImage(imageLiteralResourceName: showplaceList[selected]![selectedPlace].imageName)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.text = showplaceList[selected]![selectedPlace].name
        }
    }
    
    @IBOutlet weak var fullDescLabel: UITextView!{
        didSet{
            fullDescLabel.text = showplaceList[selected]![selectedPlace].fulldesc
        }
    }
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.dynamicBackgroundColor
        super.viewDidLoad()
    }

    
   
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
        
        let lon = showplaceList[foundCities[selectedCity].Key ]![selectedPlace].geo.Longitude
        let lat = showplaceList[  foundCities[selectedCity].Key ]![selectedPlace].geo.Latitude
        let initialLocation = CLLocation(latitude: lat , longitude: lon )
         let regionRadius: CLLocationDistance = 1000
           func centerMapOnLocation(location: CLLocation) {
               let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                         latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
             mapView.setRegion(coordinateRegion, animated: true)
           }
        }
    }
    @IBAction func clickReadMore(_ sender: Any) {
        
    }
}
