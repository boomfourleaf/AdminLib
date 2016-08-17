//
//  flLanguageSettingData.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/24/2559 BE.
//
//

import Foundation
import SwiftyJSON

extension flLanguageSettingData: Equatable { }
public func ==(lhs: flLanguageSettingData, rhs: flLanguageSettingData) -> Bool {
    return lhs.default_language == rhs.default_language
        && lhs.second_langauges == rhs.second_langauges
        && lhs.print_language_for_captain_order == rhs.print_language_for_captain_order
        && lhs.print_language_for_receipt == rhs.print_language_for_receipt
}

public struct flLanguageSettingData: flDataProtocol {
    public var default_language: String
    public var second_langauges: [String]
    
    public var print_language_for_captain_order: String
    public var print_language_for_receipt: String
    
    public init(default_language: String,
                second_langauges: [String],
                print_language_for_captain_order: String,
                print_language_for_receipt: String) {
        
        self.default_language = default_language
        self.second_langauges = second_langauges
        self.print_language_for_captain_order = print_language_for_captain_order
        self.print_language_for_receipt = print_language_for_receipt
    }
    
    public static func parse(json json: JSON) -> flLanguageSettingData? {
        flLog.info("\(json.dictionaryObjectValue)")
        
        do {
            let default_language = try getString(json: json, attribute: "default_language")
            let second_langauges = try getStringArray(json: json, attribute: "second_langauges")
            let print_language_for_captain_order = try getString(json: json, attribute: "print_language_for_captain_order")
            let print_language_for_receipt = try getString(json: json, attribute: "print_language_for_receipt")
        
            return flLanguageSettingData(
                default_language: default_language,
                second_langauges: second_langauges,
                print_language_for_captain_order: print_language_for_captain_order,
                print_language_for_receipt: print_language_for_receipt)
            
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
extension flLanguageSettingData {
    public func toDict() -> JSON {
        let dict = ["default_language": default_language,
                    "second_langauges": second_langauges,
                    "print_language_for_captain_order": print_language_for_captain_order,
                    "print_language_for_receipt": print_language_for_receipt
        ]
        
        return JSON(dict)
    }
}


//MARK: DEBUG
extension flLanguageSettingData: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        var output = ""
        output += "default_language: \(default_language)\n"
        output += "    second_langauges: \(second_langauges)\n"
        output += "    print_language_for_captain_order: \(print_language_for_captain_order)\n"
        output += "    print_language_for_receipt: \(print_language_for_receipt)\n"
        return output
    }
    
    public var debugDescription: String {
        return description
    }
}
