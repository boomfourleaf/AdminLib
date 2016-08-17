//
//  flStaffData.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/20/2559 BE.
//
//

import Foundation
import SwiftyJSON

extension flStaffData: Equatable { }
public func ==(lhs: flStaffData, rhs: flStaffData) -> Bool {
    return lhs.id == rhs.id
        && lhs.staff_id == rhs.staff_id
        
        && lhs.name == rhs.name
        && lhs.password == rhs.password
    
        && lhs.perm_cashier == rhs.perm_cashier
        && lhs.perm_close_shift == rhs.perm_close_shift
        && lhs.perm_make_order == rhs.perm_make_order
        && lhs.perm_manage_table == rhs.perm_manage_table
        && lhs.perm_print_check == rhs.perm_print_check
        && lhs.perm_stock == rhs.perm_stock
        && lhs.perm_void == rhs.perm_void
}

public struct flStaffData: flDataProtocol {
    public let id: String
    public let staff_id: String

    public var name: String
    public var password: String

    public var perm_cashier: Bool
    public var perm_close_shift: Bool
    public var perm_make_order: Bool
    public var perm_manage_table: Bool
    public var perm_print_check: Bool
    public var perm_stock: Bool
    public var perm_void: Bool
    
    public init(id: String, staff_id: String, name: String, password: String, perm_cashier: Bool, perm_close_shift: Bool, perm_make_order: Bool, perm_manage_table: Bool, perm_print_check: Bool, perm_stock: Bool, perm_void: Bool) {
        
        self.id = id
        self.staff_id = staff_id
        
        self.name = name
        self.password = password
        self.perm_cashier = perm_cashier
        self.perm_close_shift = perm_close_shift
        self.perm_make_order = perm_make_order
        self.perm_manage_table = perm_manage_table
        self.perm_print_check = perm_print_check
        self.perm_stock = perm_stock
        self.perm_void = perm_void
    }
    
    public static func parse(json json: JSON) -> flStaffData? {
        flLog.info("\(json.dictionaryObjectValue)")
        
        do {
            let id = try getString(json: json, attribute: "id")
            let staff_id = try getString(json: json, attribute: "staff_id")
            
            let name = try getString(json: json, attribute: "name")
            let password = try getString(json: json, attribute: "password")

            let perm_cashier = try getBool(json: json, attribute: "perm_cashier")
            let perm_close_shift = try getBool(json: json, attribute: "perm_close_shift")
            let perm_make_order = try getBool(json: json, attribute: "perm_make_order")
            let perm_manage_table = try getBool(json: json, attribute: "perm_manage_table")
            let perm_print_check = try getBool(json: json, attribute: "perm_print_check")
            let perm_stock = try getBool(json: json, attribute: "perm_stock")
            let perm_void = try getBool(json: json, attribute: "perm_void")
            
            return flStaffData(
                    id: id,
                    staff_id: staff_id,
                    name: name,
                    password: password,
                    perm_cashier: perm_cashier,
                    perm_close_shift:  perm_close_shift,
                    perm_make_order: perm_make_order,
                    perm_manage_table: perm_manage_table,
                    perm_print_check: perm_print_check,
                    perm_stock: perm_stock,
                    perm_void: perm_void)

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
extension flStaffData {
    public func toDict() -> JSON {
        let dict = ["id": id,
                    "name": name,
                    "password": password,
                    "perm_make_order": perm_make_order,
                    "perm_void": perm_void,
                    "perm_close_shift": perm_close_shift,
                    "perm_manage_table": perm_manage_table,
                    "perm_print_check": perm_print_check,
                    "perm_cashier": perm_cashier,
                    "perm_stock": perm_stock
            ]
        
        return JSON(dict)
    }
}


//MARK: DEBUG
extension flStaffData: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        var output = ""
        output += "id: \(id)\n"
        output += "    staff_id: \(staff_id)\n"
        output += "    name: \(name)\n"
        output += "    password: \(password)\n"
        output += "    perm_cashier: \(perm_cashier)\n"
        output += "    perm_close_shift: \(perm_close_shift)\n"
        output += "    perm_make_order: \(perm_make_order)\n"
        output += "    perm_manage_table: \(perm_manage_table)\n"
        output += "    perm_print_check: \(perm_print_check)\n"
        output += "    perm_stock: \(perm_stock)\n"
        output += "    perm_void: \(perm_void)\n"
        return output
    }
    
    public var debugDescription: String {
        return description
    }
}
