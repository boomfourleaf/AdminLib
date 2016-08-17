//
//  flService.swift
//  Dining
//
//  Created by Nattapon Nimakul on 3/5/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum flApiError {
    case NoMessage(code: Int)
    case WithMessage(code: Int, title: String, description: String)
    case UnknowWithMessage(title: String, description: String)
    
    public static func fromData(data: ObjcDictionary) -> flApiError {
        let dataJson = JSON(data)
        if let description = dataJson["description"].string {
            return .WithMessage(code: dataJson["status"].intValue, title: dataJson["status_msg"].stringValue, description: description)
        
        } else if let description = dataJson["datas"]["error_text"].string {
            return .WithMessage(code: dataJson["status"].intValue, title: dataJson["status_msg"].stringValue, description: description)
            
        } else {
            return .NoMessage(code: dataJson["status"].intValue)
        }
    }
    

    // Cloud Status updated 28 June 2016
    // 200: OK
    // 201: Not modified
    // 1000: server error
    // 1001: Price Change
    // 1002: No guest or table assigned
    // 1003: Validation Failed
    
    // Internal App
    // 2000: Internal App Error
    // 2001: Network Error
    // 9999: Unknow Error
    
    // Server Error
    public static let SERVER_ERROR_TITLE = "Your request failed"
    public static let SERVER_ERROR_DESCRIPTION = "Could not process your request, please try again or contact our staff."
    
    public static let YOUR_ORDER_FAILED_TITLE = "Your order failed"
    public static let YOUR_ORDER_FAILED_DESCRIPTION = "Could not made your order, please try again or contact our staff."
    
    // Internal App
    public static let UNKNOW_ERROR_CODE = 9999

    public static let INTERNAL_APP_ERROR_CODE = 2000
    public static let INTERNAL_APP_ERROR_TITLE = "Internal App Error"
    public static let INTERNAL_APP_ERROR_DESCRIPTION = "Could not process your request, please contact our staff."
    
    public static let INTERNET_CONNECTION_ERROR_CODE = 2001
    public static let INTERNET_CONNECTION_ERROR_TITLE = "No Internet connection"
    public static let INTERNET_CONNECTION_ERROR_DESCRIPTION = "Please check your Wifi/3G/4G and Internet connection."
    

    
}

extension flApiError {
    public static func getInternetConnectionError() -> NSError {
        let details = [NSLocalizedDescriptionKey: flApiError.INTERNET_CONNECTION_ERROR_DESCRIPTION]
        // populate the error object with the details
        return NSError(domain:flApiError.INTERNET_CONNECTION_ERROR_TITLE, code:flApiError.INTERNET_CONNECTION_ERROR_CODE, userInfo:details)
    }
    
    public  static func dataEncodingError() -> NSError {
        let details = [NSLocalizedDescriptionKey: flApiError.INTERNAL_APP_ERROR_DESCRIPTION]
        // populate the error object with the details
        return NSError(domain:flApiError.INTERNAL_APP_ERROR_TITLE, code:flApiError.INTERNAL_APP_ERROR_CODE, userInfo:details)
    }
}


public enum flServiceResponse {
    case error(error: flApiError, data: ObjcDictionary?, action: flActionParser?)
    case success(code: Int, data: ObjcDictionary)
}
