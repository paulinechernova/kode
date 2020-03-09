//
//  ShowplaceViewController.swift
//  CityWeather
//
//  Created by Admin on 03/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit
import MapKit


class ShowplaceViewController : UIViewController {
    private var shortDesc : Bool = true
    private let currentPlace : CurrentPlace = {
    let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.currentPlace) as! Data
      let place = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! CurrentPlace
        return place
    }()
    private let space : CGFloat = 10
    
    private let contentView = UIView()
    private var nameLabel = UILabel()
    private var descLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.numberOfLines = 3
        textLabel.backgroundColor = .clear
        return textLabel
    }()
    private var readMoreButton : UIButton = {
        let button = UIButton()
        button.setTitle("Читать далее", for: .normal)
        button.addTarget(self, action: #selector(readMoreAction), for: .touchUpInside)
        return button
    }()
    
    
    @objc func readMoreAction(_ sender : UIButton){
        DispatchQueue.main.async {
            if self.shortDesc {
                sender.setTitle("Свернуть", for: .normal)
                self.descLabel.numberOfLines = 0
                self.descLabel.sizeToFit()
            } else {
                sender.setTitle("Читать далее", for: .normal)
                self.descLabel.numberOfLines = 3
            }
            self.shortDesc = !self.shortDesc
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let footer = addFooter()
        setUp()
        navigationItem.title = currentPlace.name
         navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode(rawValue: 2)!
        let imageView = configureImageView()
        configureScrollView(imageView: imageView, footer : footer)
    }
    private func configureImageView() -> UIImageView {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom:  0 , paddingRight: 0, width: 0, height: (self.view.frame.size.height / 3), enableInsets: true)
        
        imageView.loadImage(url : currentPlace.imageURL )
        return imageView
    }
    private func configureScrollView(imageView: UIView, footer : UIView){
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true 
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
               
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
           
        scrollView.anchor(top: imageView.bottomAnchor, left: self.view.leftAnchor, bottom: footer.topAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        contentView.anchor(top: scrollView.topAnchor, left: nil, bottom: scrollView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        configureContentView()
    }
    
    private func configureContentView(){
        configureNameLabel(showplaceName: currentPlace.name)
        configureDescLabel()
        configureReadMoreButton()
        configureMapView()
    }
    
    private func configureNameLabel(showplaceName: String){
        nameLabel.text = showplaceName
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 33)
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: space, paddingBottom: 5, paddingRight: space, width: 0, height: 0, enableInsets: false)
    }
    private func configureDescLabel(){
        descLabel.text = currentPlace.descfull
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 3
        descLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(descLabel)
        descLabel.anchor(top: nameLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: space, paddingBottom: 0, paddingRight: space, width: 0, height: 0, enableInsets: false)
    }
    private func configureReadMoreButton(){
        contentView.addSubview(readMoreButton)
        readMoreButton.anchor(top: descLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: space, paddingBottom: 0, paddingRight: space, width: 0, height: 15, enableInsets: false)
    }
    private func configureMapView(){
        let onMapLabel =  UILabel()
        onMapLabel.text = "На карте"
        let mapView =  MKMapView()
        contentView.addSubview(onMapLabel)
        onMapLabel.font = UIFont.boldSystemFont(ofSize: 32)
        onMapLabel.anchor(top: readMoreButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: space, paddingBottom: 0, paddingRight: space, width: 0, height: 30, enableInsets: false)
        mapView.register(MapMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        contentView.addSubview(mapView)
        mapView.anchor(top: onMapLabel.bottomAnchor, left: contentView.leftAnchor , bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 250, enableInsets: false)
        let lat : Double = currentPlace.lat!
        let lon : Double = currentPlace.lon!

        let location = CLLocation(latitude: lat , longitude: lon )
        let regionRadius: CLLocationDistance = 2000
                  
        let annotation = MKPointAnnotation()
        annotation.coordinate =  CLLocationCoordinate2D( latitude: lat , longitude: lon)
        mapView.addAnnotation(annotation)
           
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

