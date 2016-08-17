//
//  flUrlConnection.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/28/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

final class flUrlConnection {
    var url: String
    var sendType: flCloudDataType
    var sendData: NSObject
    var timeout: Int
    
    public init(url: String, sendType: flCloudDataType, sendData: NSObject, timeout: Int=Int(NETWORK_SEND_REQUEST_TIMEOUT)) {
        self.url = url
        self.sendType = sendType
        self.sendData = sendData
        self.timeout = timeout
    }
}

//MARK: Error Handling
extension flUrlConnection {
    
}

//MARK: Sending Data
extension flUrlConnection {
    func fetchBySendData(contentType contentType: String? = nil) throws -> NSData? {
        //Set Request URL & Content-type
        guard let urlEscaped = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            flLog.error("Can't Add Percent Escapes for url \(url)")
            return nil
        }
        guard let requestUrl = NSURL(string:urlEscaped) else {
            flLog.error("Can't create NSURL from url \(urlEscaped)")
            return nil
        }
        
        let request = NSMutableURLRequest(URL:requestUrl)
        
        request.HTTPMethod = "POST"
        request.timeoutInterval = NSTimeInterval(timeout)
        if nil != contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        request.HTTPBody = sendData as? NSData
        
        var data: NSData?
        
        let semaphore = dispatch_semaphore_create(0)
        
        let session = NSURLSession.sharedSession() // or create your own session with your own NSURLSessionConfiguration
        let task = session.dataTaskWithRequest(request) { (backData, response, error) -> Void in
            if nil != backData
            {
                // do whatever you want with the data here
                data = backData
            }
            else
            {
                flLog.error("error = \(error)")
            }
            
            dispatch_semaphore_signal(semaphore)
        }
        task.resume()
        
        // but have the thread wait until the task is done
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        // Check internet connection problem
        if nil == data {
            throw flApiError.getInternetConnectionError()
        }
        
        return data
    }
    
    func fetchBySendPlist() throws -> NSData? {
        sendData =  try NSPropertyListSerialization.dataWithPropertyList(sendData, format: .XMLFormat_v1_0, options: 0)
        return try fetchBySendData()
    }
    
    static func toJsonData(data: NSObject) -> NSData? {
        let writer = SBJsonWriter()
        let jsonData: NSData? = writer.dataWithObject(data)
        if nil != writer.error && "" != writer.error {
            flLog.error("error: \(writer.error)")
            return nil
        }
        return jsonData
    }
    
    func fetchBySendJson() throws -> NSData? {
        guard let jsonSendData = flUrlConnection.toJsonData(sendData) else {
            flLog.error("convert to json data failed")
            throw flApiError.dataEncodingError()
        }
        
        sendData = jsonSendData
        return try fetchBySendData()
    }
    
    func addData(data: NSMutableData, fromString: String, error: String) throws {
        if let dataToAppendVaue = fromString.dataUsingEncoding(NSUTF8StringEncoding) {
            data.appendData(dataToAppendVaue)
        } else {
            flLog.error(error)
            throw NSError(domain: "append Data Error", code: 0, userInfo: nil)
        }
    }
    
    func fetchBySendJsonAndImage() throws -> NSData? {
        guard let rootData = sendData as? NSDictionary else {
            flLog.error("sendData should be Dictionary, value is \(sendData)")
            return nil
        }
        guard let data = rootData["data"] as? NSObject else {
            let wrongData = rootData["data"]
            flLog.error("rootData['data'] should be NSObject, value is \(wrongData)")
            return nil
        }
        guard let images = rootData["images"] as? [NSData] else {
            let wrongimages = rootData["images"]
            flLog.error("rootData['images'] should be [NSData], value is \(wrongimages)")
            return nil
        }
        
        // Prepare Data (Json, Images)
        guard let jsonData = flUrlConnection.toJsonData(data) else {
            flLog.error("convert to json data failed")
            throw flApiError.dataEncodingError()
        }

        /////////////////////////////////////////////////
        //Create boundary, it can be anything
        let boundary = "----AppsoluteSoftFOURLEAFfetchBySendJsonAndImage"
        
        // post body
        let body = NSMutableData()
        
        // add params (all params are strings)
        try addData(body, fromString: "--\(boundary)\r\n", error: "Begin boundary error")
        try addData(body, fromString: "Content-Disposition: form-data; name=\"data\"\r\n\r\n", error: "Content-Disposition Error")
        body.appendData(jsonData)
        
        // add images (NSData from image)
        for (i, image) in images.enumerate() {
            try addData(body, fromString: "--\(boundary)\r\n", error: "boundary error")
            try addData(body, fromString: "Content-Disposition: form-data; name=\"image\(i)\"; filename=\"image\(i).jpg\"\r\n", error: "Content-Disposition Error2")
            try addData(body, fromString: "Content-Type: image/jpeg\r\n\r\n", error: "Content-Type Error")
            body.appendData(image)
            try addData(body, fromString: "\r\n", error: "Add return line error")
        }
        
        //Close off the request with the boundary
        try addData(body, fromString: "--\(boundary)--\r\n", error: "Close Boundary error")
        sendData = body
        timeout = Int(NETWORK_SEND_REQUEST_WITH_IMAGE_TIMEOUT)
        
        return try fetchBySendData(contentType: "multipart/form-data; boundary=\(boundary)")
    }
}

//MARK: Public Method
extension flUrlConnection {
    func fetchData() throws -> NSData? {
        let responseData: NSData?
        
        switch sendType {
            
        case .plist: responseData = try fetchBySendPlist()
            
        case .jsonAndImage: responseData = try fetchBySendJsonAndImage()
            
        case .json: responseData = try fetchBySendJson()
            
        case .text:
            if let sendDataText = sendData as? String,
                data = sendDataText.dataUsingEncoding(NSUTF8StringEncoding) {
                sendData = data
                responseData = try fetchBySendData()
            } else {
                throw FetchDataError(reason: "send type is set to text, but sendData is not text, or data encoding error")
            }
            
        case .data: responseData = try fetchBySendData()
            
        case .soap:
            if let sendDataText = sendData as? String,
                data = sendDataText.dataUsingEncoding(NSUTF8StringEncoding) {
                sendData = data
                responseData = try fetchBySendData(contentType:"application/soap+xml;charset=UTF-8")
            } else {
                throw FetchDataError(reason: "send type is set to soap, but sendData is not text, or data encoding error")
            }
        default: throw FetchDataError(reason: "sendType \(sendType) is not supported")
        }
        
        return responseData
    }
    
    func plistFetch() -> JSON? {
        do {
            let responseData = try fetchData()
            return responseData?.plist
        
        // Cannot made an order
        } catch let error as NSError {
            let dict: ObjcDictionary = ["datas": ["error_text": error.localizedDescription],
                                        "status": error.code,
                                        "status_msg": error.domain]
            
            flLog.error(error.localizedDescription)
            return JSON(dict)

        } catch let error as FetchDataError {
            let dict: ObjcDictionary = ["status" : 9999, "status_msg": "error"]

            flLog.error(error.reason)
            return JSON(dict)
        }
    }
}

//MARK: Error
extension flUrlConnection {
    struct FetchDataError: ErrorType {
        let reason: String
    }
}
