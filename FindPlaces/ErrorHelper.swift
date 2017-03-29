//
//  ErrorHelper.swift
//  FindPlaces
//
//  Created by Alex on 3/28/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation

class ErrorHelper {
    func getErrorMessage (statusCode: Int) -> String {
        var message: String?
        if (statusCode >= 400 && statusCode < 500) {
            message = "Request Error"
        } else if (statusCode >= 500 && statusCode < 600) {
            message = "Service unavailable"
        } else {
            message = "No connection, check and try again"
        }
        return message!
    }
    
}
