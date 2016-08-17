//
//  flTableZoneData.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/22/2559 BE.
//
//

import Foundation
import SwiftyJSON

extension flTableZoneData: Equatable { }
public func ==(lhs: flTableZoneData, rhs: flTableZoneData) -> Bool {
    return lhs.id == rhs.id
        && lhs.active == rhs.active
        && lhs.order == rhs.order
        && lhs.zone == rhs.zone
}

public struct flTableZoneData: flDataProtocol {
    public let id: String
    public let active: Bool
    public var order: Int
    public var zone: String
    
    public init(id: String, active: Bool, order: Int, zone: String) {
        self.id = id
        self.active = active
        self.order = order
        self.zone = zone
    }
    
    public static func parse(json json: JSON) -> flTableZoneData? {
        flLog.info("\(json.dictionaryObjectValue)")
        
        do {
            let id = try getString(json: json, attribute: "id")
            let active = try getBool(json: json, attribute: "active")
            let order = try getInt(json: json, attribute: "order")
            let zone = try getString(json: json, attribute: "zone")
        
            return flTableZoneData(
                id: id,
                active: active,
                order: order,
                zone: zone)
            
        } catch let error as ParsingFailedError {
            flLog.error("\(error.message)")
            return nil
            
        } catch {
            flLog.error("Unknown error")
            return nil
        }
    }
}

// Cloud Dictionary
extension flTableZoneData {
    public func toDict() -> JSON {
        let dict = ["id": id,
                    "active": active,
                    "order": order,
                    "zone": zone
        ]
        
        return JSON(dict)
    }
}


//MARK: DEBUG
extension flTableZoneData: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        var output = ""
        output += "id: \(id)\n"
        output += "    active: \(active)\n"
        output += "    order: \(order)\n"
        output += "    zone: \(zone)\n"
        return output
    }
    
    public var debugDescription: String {
        return description
    }
}
