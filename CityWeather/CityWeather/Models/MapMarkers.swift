//
//  MapMarkers.swift
//  CityWeather
//
//  Created by Admin on 01/03/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import MapKit

class MapMarker: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
        markerTintColor = UIColor.blue
        }
    }
}
