//
//  flReceiptData.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/24/2559 BE.
//
//

import Foundation
import SwiftyJSON

extension flReceiptData: Equatable { }
public func ==(lhs: flReceiptData, rhs: flReceiptData) -> Bool {
    return lhs.service_charge == rhs.service_charge
        && lhs.service_charge_mode == rhs.service_charge_mode
        
        && lhs.vat == rhs.vat
        && lhs.vat_mode == rhs.vat_mode
        
        && lhs.misc == rhs.misc
        
        && lhs.show_vat == rhs.show_vat
        && lhs.show_service_charge == rhs.show_service_charge
        && lhs.show_misc == rhs.show_misc
        
        && lhs.logo == rhs.logo
        && lhs.name == rhs.name
        && lhs.address == rhs.address
        && lhs.tail_bill == rhs.tail_bill
        && lhs.show_order_note == rhs.show_order_note
}

public enum ServiceChargeMode: String, CustomStringConvertible {
    case INC, EXC
    
    public var description: String {
        switch self {
        case .INC: return "Included"
        case .EXC: return "Exclude"
        }
    }
}

public enum VatMode: String, CustomStringConvertible {
    case INC, EXC
    
    public var description: String {
        switch self {
        case .INC: return "Included"
        case .EXC: return "Exclude"
        }
    }
}

public enum MiscMode: String {
    case AUTO, HALF, DISA
    
    public var description: String {
        switch self {
        case .AUTO: return "Always Round Up (Default)"
        case .HALF: return "Half Round Up"
        case .DISA: return "Disable"
        }
    }
}

public struct flReceiptData: flDataProtocol {
    
    public var service_charge: NSDecimalNumber
    public var service_charge_mode: ServiceChargeMode
    
    public var vat: NSDecimalNumber
    public var vat_mode: VatMode
    
    public var misc: MiscMode
    
    public var show_vat: Bool
    public var show_service_charge: Bool
    public var show_misc: Bool
    
    public var logo: UIImage?
    public var name: String
    public var address: String
    public var tail_bill: String
    public var show_order_note: Bool
    
    public init(service_charge: NSDecimalNumber,
                service_charge_mode: ServiceChargeMode,
                
                vat: NSDecimalNumber,
                vat_mode: VatMode,
                
                misc: MiscMode,
                
                show_vat: Bool,
                show_service_charge: Bool,
                show_misc: Bool,
                
                logo: UIImage?,
                name: String,
                address: String,
                tail_bill: String,
                show_order_note: Bool) {
        
        self.service_charge = service_charge
        self.service_charge_mode = service_charge_mode
        
        self.vat = vat
        self.vat_mode = vat_mode
    
        self.misc = misc
    
        self.show_vat = show_vat
        self.show_service_charge = show_service_charge
        self.show_misc = show_misc
    
        self.logo = logo
        self.name = name
        self.address = address
        self.tail_bill = tail_bill
        self.show_order_note = show_order_note
    }

    public static func parse(json json: JSON) -> flReceiptData? {
        flLog.info("\(json.dictionaryObjectValue)")
        
        do {
            let service_charge = try getDecimal(json: json, attribute: "service_charge")
            let service_charge_mode = try getServiceChargeMode(json: json, attribute: "service_charge_mode")
                
            let vat = try getDecimal(json: json, attribute: "vat")
            let vat_mode = try getVatMode(json: json, attribute: "vat_mode")
            
            let misc = try getMiscMode(json: json, attribute: "misc")
            
            let show_vat = try getBool(json: json, attribute: "show_vat")
            let show_service_charge =  try getBool(json: json, attribute: "show_service_charge")
            let show_misc =  try getBool(json: json, attribute: "show_misc")
            
            let logo = try getImage(json: json, attribute: "logo")
            let name = try getString(json: json, attribute: "name")
            let address = try getString(json: json, attribute: "address")
            let tail_bill = try getString(json: json, attribute: "tail_bill")
            let show_order_note = try getBool(json: json, attribute: "show_order_note")

            return flReceiptData(
                service_charge: service_charge,
                service_charge_mode: service_charge_mode,
                
                vat: vat,
                vat_mode: vat_mode,
                
                misc: misc,
                
                show_vat:  show_vat,
                show_service_charge: show_service_charge,
                show_misc: show_misc,
                
                logo: logo,
                name: name,
                address: address,
                tail_bill: tail_bill,
                show_order_note: show_order_note)

        } catch let error as ParsingFailedError {
            flLog.error("\(error.message)")
            return nil

        } catch {
            flLog.error("Unknown error")
            return nil
        }
    }
}

extension flReceiptData {
    public static func getServiceChargeMode(json json: JSON, attribute: String) throws -> ServiceChargeMode {
        guard let output = ServiceChargeMode(rawValue: json[attribute].stringValue) else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
    
    public static func getVatMode(json json: JSON, attribute: String) throws -> VatMode {
        guard let output = VatMode(rawValue: json[attribute].stringValue) else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
    
    public static func getMiscMode(json json: JSON, attribute: String) throws -> MiscMode {
        guard let output = MiscMode(rawValue: json[attribute].stringValue) else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
}

// Cloud Dict
extension flReceiptData {
    public func toDict() -> JSON {
        let dict = ["service_charge": service_charge,
                    "service_charge_mode": service_charge_mode.rawValue,
                    
                    "vat": vat,
                    "vat_mode": vat_mode.rawValue,
                    
                    "misc": misc.rawValue,
                    "show_service_charge": show_service_charge,
                    "show_vat": show_vat,
                    "show_misc": show_misc,
                    
                    "name": name,
                    "address": address,
                    "tail_bill": tail_bill,
                    "show_order_note": show_order_note
        ]
        
        return JSON(dict)
    }
}


//MARK: DEBUG
extension flReceiptData: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        var output = ""
        output += "service_charge: \(service_charge)\n"
        output += "    service_charge_mode: \(service_charge_mode)\n"
        
        output += "    vat: \(vat)\n"
        output += "    vat_mode: \(vat_mode)\n"
        
        output += "    misc: \(misc)\n"
        
        output += "    show_vat: \(show_vat)\n"
        output += "    show_service_charge: \(show_service_charge)\n"
        output += "    show_misc: \(show_misc)\n"
        
        output += "    logo: \(logo)\n"
        output += "    name: \(name)\n"
        output += "    address: \(address)\n"
        output += "    tail_bill: \(tail_bill)\n"
        output += "    show_order_note: \(show_order_note)\n"
        return output
    }
    
    public var debugDescription: String {
        return description
    }
}
