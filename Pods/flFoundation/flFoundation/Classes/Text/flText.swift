//
//  flText.swift
//  Dining
//
//  Created by Nattapon Nimakul on 7/6/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: Localized String
public func localize(text: String, languageKey: String?=nil, comment: String?=nil) -> String {
    return flText.localize(text, languageKey: languageKey)
}

public func localize(data: JSON, key: String, autoLang: Bool=true, forEmpty: String?=nil, backupKey: String?=nil) -> String {
    return flText.getString(data, key: key, autoLang: autoLang, forEmpty: forEmpty, backupKey: backupKey)
}

public func localize(data: JSON, key: String, languageSuffix: String?, backupKey: String?=nil) -> String {
    return flText.getString(data, key: key, languageSuffix: languageSuffix, backupKey: backupKey)
}

//MARK: flText
public struct flText {
    public static func dateToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeZone = NSTimeZone(name: "'Asia/Bangkok'")
        return formatter.stringFromDate(date)
    }
    
    public static func getString(data: JSON, key: String, languageSuffix: String?, backupKey: String?=nil) -> String {
        // Get object from key (or backupkey)
        let obj: AnyObject
        // Object from key
        if  let objTmp = objectWithData(data, key: key, languageSuffix: languageSuffix) {
            obj = objTmp
        // Object from backup key
        } else {
            guard let backupKeyValue = backupKey else { return "" }
            guard let objTmp = objectWithData(data, key: backupKeyValue, languageSuffix: languageSuffix) else { return "" }
            obj = objTmp
        }
        
        // Number with option parsing
        if let number = obj as? NSNumber,
            option = data[key + "_option"].string {
                return getStringWithNumber(number, option: option)
        }
        
        // Normal mode parsing
        switch obj {
        case let text as String: return text
        case let number as NSNumber: return number.stringValue
        case let date as NSDate: return dateToString(date)
        default: return ""
        }
    }
    
    public static func getString(data: JSON, key: String, autoLang: Bool=true, forEmpty: String?=nil, backupKey: String?=nil) -> String {
        let output = getString(data, key: key, languageSuffix: autoLang ? flLanguageController.cacheKeySuffix : "", backupKey: backupKey)
        if "" == output {
            return forEmpty ?? ""
        } else {
            return output
        }
    }
    
    public static func getStringWithNumber(number: NSNumber, option: String) -> String {
        switch option {
            // Old Style
        case "currency_baht":
            return getStringWithCurrencyBaht(number)
        case "currency_baht_sign_and_two_decimal":
            return getStringWithCurrencyBahtSignTwoDecimal(number)
        case "currency_no_baht_sign_and_two_decimal":
            return getStringWithCurrencyBahtSignTwoDecimalWithoutCurrency(number)
        case "currency_baht_sign_max_two_decimal":  // ฿12.-, ฿12.12
            return getStringPriceListMaximumTwoDecimal(number)
        case "currency_no_baht_sign_max_two_decimal":
            return getStringPriceListMaximumTwoDecimalWithoutCurrency(number)
            
            // New Style
        case "currency_decimal_comma": // 450.00 | 1,147.50 | 1,234.56
            return stringTwoDecimalWithSeperateComma(number)
            
        case "currency_comma": // // 450 | 1,147.5 | 1,234.56
            return stringWithSeperateComma(number)
        
        case "currency_comma_baht_sign": // // 450 | 1,147.5 | 1,234.56
            return stringWithSeperateComma(number, bahtSign: true)
            
        default:
            return number.stringValue
        }
    }
    
    public static func getStringWithCurrencyBaht(number: NSNumber?) -> String {
        guard let uwpNumber = number else { return "" }

        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.locale = NSLocale(localeIdentifier: "th_TH")
        let currencyString = currencyFormatter.internationalCurrencySymbol //EUR, GBP, USD...
        var format = currencyFormatter.positiveFormat
        if let uwpCurrencyString = currencyString {
            format = format.stringByReplacingOccurrencesOfString("¤", withString: uwpCurrencyString)
        }
        // ¤ is a placeholder for the currency symbol
        currencyFormatter.positiveFormat = format
        
        return currencyFormatter.stringFromNumber(uwpNumber) ?? ""
    }
    
    public static func getStringWithCurrencyBahtSignTwoDecimal(number: NSNumber?) -> String {
        guard let uwpNumber = number else { return "" }
        let output = String(format: "฿%.2f", uwpNumber.floatValue)
        return fixMinusBahtSignAwkwardDisplay(output)
    }
    
    public static func getStringWithCurrencyBahtSignTwoDecimalWithoutCurrency(number: NSNumber?) -> String {
        guard let uwpNumber = number else { return "" }
        return String(format: "%.2f", uwpNumber.floatValue)
    }
    
    public static func stringTwoDecimalWithSeperateComma(number: NSNumber?) -> String {
        guard let numberValue = number else { return "" }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencySymbol = ""
        return formatter.stringFromNumber(numberValue) ?? ""
    }
    
    public static func stringWithSeperateComma(number: NSNumber?, bahtSign: Bool = false, maxDecimalPlaces: Int?=nil) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        if let maxDecimalPlacesValue = maxDecimalPlaces {
            formatter.maximumFractionDigits = maxDecimalPlacesValue
        }
        
        guard let uwpNumber = number else { return "" }
        guard let formatted = formatter.stringFromNumber(uwpNumber) else { return "" }
        let output = bahtSign ? "฿" + formatted : formatted
        return fixMinusBahtSignAwkwardDisplay(output)
    }
    
    public static func getStringNumberMaximumTwoDecimal(number: NSNumber?, zeroDecimalFormat zeroFormat: String?, decimalFormat: String?) -> String {
        if var num = number?.floatValue {
            // round up if >= 0.5
            num = roundf(num * 100.0) / 100.0
            
            // check if no decimal
            var decimal = Int(num * 100.0)
            decimal = decimal % 100
            
            
            if decimal == 0 {
                if let uwpZeroFormat = zeroFormat {
                    return String(format: uwpZeroFormat, num)
                }
            } else {
                if let uwpDecimalFormat = decimalFormat {
                    return String(format: uwpDecimalFormat, num)
                }
            }
        }
        return ""
    }
    
    public static func getStringNumberMaximumTwoDecimal(number: NSNumber?) -> String {
        return getStringNumberMaximumTwoDecimal(number,
            zeroDecimalFormat: "%.0f",
            decimalFormat: "%g")
    }
    
    public static func getStringPriceListMaximumTwoDecimal(number: NSNumber?) -> String {
        let output = getStringNumberMaximumTwoDecimal(number,
            zeroDecimalFormat: "฿%.0f.-",
            decimalFormat: "฿%g")
        
        return fixMinusBahtSignAwkwardDisplay(output)
    }
    
    public static func getStringPriceListMaximumTwoDecimalWithoutCurrency(number: NSNumber?) -> String {
        return getStringNumberMaximumTwoDecimal(number,
            zeroDecimalFormat: "%.0f.-",
            decimalFormat: "%g")
    }
}

//MARK: Helper
extension flText {
    /**
    Find a object in data dictionary using key with/or langauge
    
    - parameter data: a dictionary
    - parameter key: dictionary key
    - parameter languageSuffix: optional language key suffix
    
    Example: let name = objectWithData(['name': 'my name', 'name_th': 'name in thai'], key: 'name', languageSuffix: '_th')
    
    - returns: Return a object found by key with languate or key or null
    */
    private static func objectWithData(data: ObjcDictionary, key: String, languageSuffix: String?) -> AnyObject? {
        if let languageSuffixValue = languageSuffix {
            if let obj = data[key + languageSuffixValue] {
                return obj
            }
        }
        
        return data[key]
    }
    
    private static func objectWithData(data: JSON, key: String, languageSuffix: String?) -> AnyObject? {
        if let languageSuffixValue = languageSuffix {
            let obj = data[key + languageSuffixValue]
            if obj.isExists() {
                return obj.object
            }
        }
        
        let obj = data[key]
        return obj.isExists() ? obj.object : nil
    }
    
    private static func fixMinusBahtSignAwkwardDisplay(text: String) -> String {
        // ฿-10.12 =>  -฿10.12
        var output = text
        if "฿-" == output[0...1] {
            output[0...1] = "-฿"
        }
        return output
    }
}

// Localization
extension flText {
    static let bundles = [NSBundle.mainBundle(), FOURLEAFFoundationBundle.mainBundle]
    
    /**
     Localize Text with langauge files bundle
     
     - parameter languageKey: "en", "th"
     */
    public static func localize(text: String, languageKey: String?) -> String {
        // Try localize each bundle
        for bundle in bundles {

            let localizedText: String
            if let languageKeyValue = languageKey {
                localizedText = bundle.localizedStringForKey(text, value: nil, table: languageKeyValue)
            } else {
                localizedText = bundle.localizedStringForKey(text, value: nil, table: flLanguageController.cacheKey)
            }

            if localizedText != text {
                return localizedText
            }
        }
        return text
	}
}
