//
//  flPrintSettingData.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/24/2559 BE.
//
//

import Foundation
import SwiftyJSON

extension flPrintSettingData: Equatable { }
public func ==(lhs: flPrintSettingData, rhs: flPrintSettingData) -> Bool {
    return lhs.print_on_move_table == rhs.print_on_move_table
        && lhs.print_on_void_item == rhs.print_on_void_item
        && lhs.print_receipt_copy == rhs.print_receipt_copy
        && lhs.print_name_format_for_captain_order == rhs.print_name_format_for_captain_order
}

public enum PrintNameFormat: String {
    case name, group_name, category_group_name
}

public struct flPrintSettingData: flDataProtocol {
    public var print_on_move_table: Bool
    public var print_on_void_item: Bool
    public var print_receipt_copy: Int
    public var print_name_format_for_captain_order: PrintNameFormat
    
    public init(print_on_move_table: Bool,
                print_on_void_item: Bool,
                print_receipt_copy: Int,
                print_name_format_for_captain_order: PrintNameFormat) {
        
        self.print_on_move_table = print_on_move_table
        self.print_on_void_item = print_on_void_item
        self.print_receipt_copy = print_receipt_copy
        self.print_name_format_for_captain_order = print_name_format_for_captain_order
    }
    
    public static func parse(json json: JSON) -> flPrintSettingData? {
        flLog.info("\(json.dictionaryObjectValue)")
        
        do {
            let print_on_move_table = try getBool(json: json, attribute: "print_on_move_table")
            let print_on_void_item = try getBool(json: json, attribute: "print_on_void_item")
            let print_receipt_copy = try getInt(json: json, attribute: "print_receipt_copy")
            let print_name_format_for_captain_order = try getPrintNameFormat(json: json, attribute: "print_name_format_for_captain_order")
        
            return flPrintSettingData(
                print_on_move_table: print_on_move_table,
                print_on_void_item: print_on_void_item,
                print_receipt_copy: print_receipt_copy,
                print_name_format_for_captain_order: print_name_format_for_captain_order)

        } catch let error as ParsingFailedError {
            flLog.error("\(error.message)")
            return nil
            
        } catch {
            flLog.error("Unknown error")
            return nil
        }
    }
}

extension flPrintSettingData {
    public static func getPrintNameFormat(json json: JSON, attribute: String) throws -> PrintNameFormat {
        guard let output = PrintNameFormat(rawValue: json[attribute].stringValue) else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
}

// Cloud Dict
extension flPrintSettingData {
    public func toDict() -> JSON {
        let dict = ["print_on_move_table": print_on_move_table,
                    "print_on_void_item": print_on_void_item,
                    "print_receipt_copy": print_receipt_copy,
                    "print_name_format_for_captain_order": print_name_format_for_captain_order.rawValue
        ]
        
        return JSON(dict)
    }
}


//MARK: DEBUG
extension flPrintSettingData: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        var output = ""
        output += "print_on_move_table: \(print_on_move_table)\n"
        output += "    print_on_void_item: \(print_on_void_item)\n"
        output += "    print_receipt_copy: \(print_receipt_copy)\n"
        output += "    print_name_format_for_captain_order: \(print_name_format_for_captain_order)\n"
        return output
    }
    
    public var debugDescription: String {
        return description
    }
}
