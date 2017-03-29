//
//  NetworkManager.swift
//  FindPlaces
//
//  Created by Alex on 3/28/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    let api = GooglePlacesAPI()
    
    func getGooglePlaces(keyWord: String, lat: Double, lon: Double, completionHandler: @escaping (Array<AnyObject>?, Int?) -> ()) -> () {
        let googleAPIUrl = api.getUrlGoogleAPIbyDistance(lat: lat, lon: lon, keyWord: keyWord)
        Alamofire.request(googleAPIUrl!).responseJSON { response in
            
            var statusCode = response.response?.statusCode
            if let error = response.result.error as? AFError {
                statusCode = error._code
            }
            
            var placeArray: Array<AnyObject>?
            if let JSON = response.result.value {
                let placeConverter: PlaceConverter? = PlaceConverter()
                placeArray = placeConverter?.convertModel(json: JSON as! NSDictionary)
            }
            completionHandler(placeArray, statusCode)
        }
    }
}
