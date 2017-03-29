//
//  Place.swift
//  FindPlaces
//
//  Created by Alex on 3/28/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import CoreLocation
import Unbox

class Place: Unboxable{
    
    var name: String?
    var openNow: String?
    var icon: String?
    var vicinity: String?
    var coordinate: CLLocationCoordinate2D?
    
    required init(unboxer: Unboxer) {
        self.name = unboxer.unbox(key: "name")
        self.openNow = unboxer.unbox(keyPath: "opening_hours.open_now")
        self.icon = unboxer.unbox(key: "icon")
        self.vicinity = unboxer.unbox(key: "vicinity")
        let longitude = unboxer.unbox(keyPath: "geometry.location.lng") as Double?
        let latitude = unboxer.unbox(keyPath: "geometry.location.lat") as Double?
        self.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    
    
    /* Distance calculator */
    func formatedDistanceFrom(cooridnate: CLLocationCoordinate2D) -> String {
        
        let earthRadius = CGFloat(6371009.0)
        let degreesToRadians = Double.pi/180.0
        let meterToMile = CGFloat(0.000621371)
        
        let latitude1: CGFloat = CGFloat(self.coordinate!.latitude * degreesToRadians)
        let latitude2: CGFloat = CGFloat(cooridnate.latitude * degreesToRadians)
        let dLatitude = latitude1 - latitude2
        
        let longitude1: CGFloat = CGFloat(self.coordinate!.longitude * degreesToRadians)
        let longitude2: CGFloat = CGFloat(cooridnate.longitude * degreesToRadians)
        let dLongitude = longitude1 - longitude2
        
        let k: CGFloat = CGFloat(pow(sin(0.5*dLatitude), 2.0) + cos(latitude1)*cos(latitude2)*pow(sin(0.5*dLongitude), 2.0))
        let distanceMeters: CGFloat = CGFloat(2.0 * earthRadius * asin(sqrt(k)))
        let distanceMiles = distanceMeters * meterToMile
        return String(format:"%.2fmi", distanceMiles)
    }
}
