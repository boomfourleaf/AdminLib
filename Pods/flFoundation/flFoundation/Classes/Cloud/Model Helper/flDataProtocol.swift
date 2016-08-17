//
//  flDataProtocol.swift
//  Pods
//
//  Created by Nattapon Nimakul on 7/5/2559 BE.
//
//

import Foundation
import SwiftyJSON

public protocol flDataProtocol {
    static func parse(json json: JSON) -> Self?
    func toDict() -> JSON
}

extension flDataProtocol {
    public static func getBool(json json: JSON, attribute: String) throws -> Bool {
        guard let output = json[attribute].bool else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
    
    public static func getInt(json json: JSON, attribute: String) throws -> Int {
        guard let output = json[attribute].int else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
    
    public static func getString(json json: JSON, attribute: String) throws -> String {
        guard let output = json[attribute].string else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
    
    public static func getStringArray(json json: JSON, attribute: String) throws -> [String] {
        guard let output = json[attribute].array?.flatMap({ $0.string }) else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
    
    public static func getDecimal(json json: JSON, attribute: String) throws -> NSDecimalNumber {
        guard let output = json[attribute].decimal else { throw ParsingFailedError(attribute: attribute, json: json) }
        return output
    }
    
    public static func getImage(json json: JSON, attribute: String) throws -> UIImage {
        let pictureData = flApi.getPicData(json, name: attribute)
        let isSyncSuccess = flApi.syncImage(pictureData)
        
        if isSyncSuccess {
            let logoPath = flImageCache.imagePathForData(pictureData)
            
            if let image = UIImage(contentsOfFile:logoPath) {
                return image
            } else {
                throw ParsingFailedError(attribute: attribute, message: "Can not load image from \(logoPath)")
            }
        } else {
            throw ParsingFailedError(attribute: attribute, json: json)
        }
    }
}

