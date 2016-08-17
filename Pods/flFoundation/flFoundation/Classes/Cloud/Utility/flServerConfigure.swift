//
//  flServerConfigure.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/21/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class flServerConfigure: NSObject {
    public static var shareObject: flServerConfigure = {
        let obj = flServerConfigure()
        obj.loadFromPersistance()
        return obj
    }()

    public var http = "" // "https"
    public var server = "" //"dev.afourleaf.com"
    public var port = 80
    public var printServiceEnable = false
    public var printServiceNames = [String]()
    
    public var rootUrl: String { get { return "\(http)://\(server)" + (80 == port ? "" : ":\(port)") } }
    // Exp: dev
    public var customerName: String { get { return server.componentsSeparatedByString(".afourleaf.com")[0] } }
    public var isActivated: Bool { get { return server != "" } }
    
    public func updateWithData(data: ObjcDictionary) -> Bool {
        let dataJson = JSON(data)
        if let server = dataJson["data"]["server"].string,
            let http = dataJson["data"]["http"].string {
            flLog.info("\(http)://\(server)")
            flServerConfigure.shareObject.server = server
            flServerConfigure.shareObject.http = http
            flServerConfigure.shareObject.saveToPersistance()
            return true
        } else {
            return false
        }
    }
}

// MARK: Persistance
extension flServerConfigure {
    struct Config {
        static let CONFIGURE_PERSISTANCE_KEY = "flServerConfigure_Persistance"
    }
    
    internal func loadFromPersistance() {
        if let data = flPersistData.objForKey(Config.CONFIGURE_PERSISTANCE_KEY) as? ObjcDictionary {
            let dataJson = JSON(data)
            http = dataJson["http"].stringValue
            server = dataJson["server"].stringValue
            port = dataJson["port"].intValue
            printServiceEnable = dataJson["printServiceEnable"].boolValue
            if let persistancePrintServiceNames = dataJson["printServiceNames"].arrayObject as? [String] {
                printServiceNames = persistancePrintServiceNames
            }
        }
    }
    
    internal func saveToPersistance() {
        var data = ObjcDictionary()
        data["http"] = http
        data["server"] = server
        data["port"] = port
        data["printServiceEnable"] = printServiceEnable
        data["printServiceNames"] = printServiceNames
        flPersistData.setObj(data, forKey: Config.CONFIGURE_PERSISTANCE_KEY)
    }
}
