//
//  UIViewContoller + extension.swift
//  CityWeather
//
//  Created by Admin on 29/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    func addFooter() -> UIView {

        let footer = UIView()

        footer.clipsToBounds = true
        footer.frame = self.view.bounds.inset(by: .init(top: self.view.frame.size.height - 80 , left: 0, bottom: 0, right: 0))
         self.view.addSubview(footer)

         //footer.anchor(top: self.view.bottomAnchor , left: self.view.leftAnchor , bottom: self.view.bottomAnchor, right: self.view.rightAnchor , paddingTop: -80, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        footer.backgroundColor = UIColor.dynamicBackgroundColor
        let label = addLabel(mainView: footer)
        footer.addSubview(label)
        let logo = addLogo(mainView: footer)
        footer.addSubview(logo)
        return footer
    }
    
    private func addLabel( mainView : UIView ) -> UIView {
        let label = UILabel()
        label.clipsToBounds = true
        label.text = "Сделано с любовью"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.frame = mainView.bounds.inset(by: .init(top: 0, left: 0, bottom: 40, right: 0))
        return label
    }
    
    private func addLogo( mainView : UIView ) -> UIView{
        let logo = UIImageView()
        logo.image = UIImage( imageLiteralResourceName: "kode")
        logo.contentMode = .scaleAspectFit
        logo.frame = mainView.bounds.inset(by: .init(top: 33, left: 0, bottom: 30, right: 0))
        return logo
    }
    
    
    struct UserDefaultKeys {
        static let coordinatesCity = "coordinatesCity"
        static let lastSearchCities = "lastSearchCities"
        static let currentPlace = "currentPlace"
        static let getPlacesList = "getPlacesList"
    }
}
extension UIViewController {
    static let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func insertCity(cityName : String, cityKey: String){
        let newCity = CoreCity(context: UIViewController.context)
              newCity.name = cityName
              newCity.key = cityKey
        UIViewController.context.insert(newCity)
           do {
            try UIViewController.self.context.save()
           } catch{
               print(error)
           }
       }
          func insertPlace(cityKey : String, name : String, imageUrl : String, desc: String, descfull: String, lon : Double, lat : Double){
            let newGeo = Geo(context: UIViewController.context)
               newGeo.lat = lat
               newGeo.lon = lon
            let newPlace = Place(context: UIViewController.context)
               newPlace.desc = desc
               newPlace.descfull = descfull
               newPlace.geo = newGeo
               newPlace.name = name
               newPlace.imageURL = imageUrl
               
            if let city = fetchCity(cityKey: cityKey) {
               city.addToPlace(newPlace)
                UIViewController.context.insert(newPlace)
              do {
                try UIViewController.self.context.save()
                  } catch {
                   print(error)
              }
           }

       }
       
       private func fetchCity(cityKey: String) -> CoreCity? {
           var cities: [CoreCity]? = nil
           do {
            cities = try UIViewController.context.fetch(CoreCity.fetchRequest())
               for town in cities! {
                   if town.key == cityKey {
                       return town
                   }
               }
           } catch let error as NSError {
               print("Could not fetch request \(error), \(error.userInfo)")
               return nil
           }
           return nil
       }
       
       func fetchPlaces(cityKey : String) -> NSSet {
           if let currentCity = fetchCity(cityKey: cityKey)  {
               return currentCity.place!
           }
           return []
       }
    func setUp(){
        self.view.backgroundColor = .dynamicBackgroundColor
        navigationController?.navigationBar.backgroundColor = .dynamicBackgroundColor
        navigationController?.navigationBar.barTintColor = .dynamicBackgroundColor
    }
}
