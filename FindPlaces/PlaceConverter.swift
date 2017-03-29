//
//  PlaceConverter.swift
//  FindPlaces
//
//  Created by Alex on 3/28/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import Unbox

class PlaceConverter{
    
    func convertModel(json: NSDictionary) -> Array<AnyObject> {
        var placesArray = [AnyObject]()
        let jsonResults: Array<AnyObject>
        jsonResults = json["results"] as! Array<AnyObject>
        for jsonPlaces in jsonResults {
            do{
                let place: Place = try unbox(dictionary: jsonPlaces as! UnboxableDictionary)
                placesArray.append(place)
            } catch {
                print(error.localizedDescription)
            }
        }
        return placesArray
    }
}
