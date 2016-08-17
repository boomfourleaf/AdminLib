//
//  flStaffSettingData.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/24/2559 BE.
//
//

import Foundation
import SwiftyJSON

extension flStaffSettingData: Equatable { }
public func ==(lhs: flStaffSettingData, rhs: flStaffSettingData) -> Bool {
    return lhs.require_staff_signature == rhs.require_staff_signature
}

public struct flStaffSettingData: flDataProtocol {
    public var require_staff_signature: Bool
    
    public init(require_staff_signature: Bool) {
        self.require_staff_signature = require_staff_signature
    }
    
    public static func parse(json json: JSON) -> flStaffSettingData? {
        flLog.info("\(json.dictionaryObjectValue)")
        
        do {
            let require_staff_signature = try getBool(json: json, attribute: "require_staff_signature")
            
            return flStaffSettingData(
                require_staff_signature: require_staff_signature)

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
extension flStaffSettingData {
    public func toDict() -> JSON {
        let dict = ["require_staff_signature": require_staff_signature
        ]
        
        return JSON(dict)
    }
}


//MARK: DEBUG
extension flStaffSettingData: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        var output = ""
        output += "require_staff_signature: \(require_staff_signature)\n"
        return output
    }
    
    public var debugDescription: String {
        return description
    }
}
