//
//  flTableNameData.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/22/2559 BE.
//
//

import Foundation
import SwiftyJSON

extension flTableNameData: Equatable { }
public func ==(lhs: flTableNameData, rhs: flTableNameData) -> Bool {
    return lhs.id == rhs.id
        && lhs.category_id == rhs.category_id
        && lhs.active == rhs.active
        && lhs.order == rhs.order
        && lhs.table_name == rhs.table_name
}

public struct flTableNameData: flDataProtocol {
    public let id: String
    public let category_id: String
    public let active: Bool
    public var order: Int
    public var table_name: String
    
    public init(id: String, category_id: String, active: Bool, order: Int, table_name: String) {
        self.id = id
        self.category_id = category_id
        self.active = active
        self.order = order
        self.table_name = table_name
    }
    
    public static func parse(json json: JSON) -> flTableNameData? {
        flLog.info("\(json.dictionaryObjectValue)")
        
        do {
            let id = try getString(json: json, attribute: "id")
            let category_id = try getString(json: json, attribute: "category_id")
            let active = try getBool(json: json, attribute: "active")
            let order = try getInt(json: json, attribute: "order")
            let table_name = try getString(json: json, attribute: "table_name")
            
            return flTableNameData(
                id: id,
                category_id: category_id,
                active: active,
                order: order,
                table_name: table_name)
            
        } catch let error as ParsingFailedError {
            flLog.error("\(error.message)")
            return nil
            
        } catch {
            flLog.error("Unknown error")
            return nil
        }
    }
}

// Cloud Dict
extension flTableNameData {
    public func toDict() -> JSON {
        let dict = ["id": id,
                    "category_id": category_id,
                    "active": active,
                    "order": order,
                    "table_name": table_name
        ]
        
        return JSON(dict)
    }
}


//MARK: DEBUG
extension flTableNameData: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        var output = ""
        output += "id: \(id)\n"
        output += "    category_id: \(category_id)\n"
        output += "    active: \(active)\n"
        output += "    order: \(order)\n"
        output += "    table_name: \(table_name)\n"
        return output
    }
    
    public var debugDescription: String {
        return description
    }
}
