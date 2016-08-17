//
//  flLanguageController.swift
//  Dining
//
//  Created by Nattapon Nimakul on 7/6/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

extension flLanguageData: Equatable { }
public func ==(lhs: flLanguageData, rhs: flLanguageData) -> Bool {
    return lhs.display ==       rhs.display &&
           lhs.key ==           rhs.key &&
           lhs.shortDisplay ==  rhs.shortDisplay &&
           lhs.locale_code ==   rhs.locale_code
}

public struct flLanguageData {
    public let display: String
    public let key: String
    public let shortDisplay: String
    public let locale_code: String
    
    public var locale: NSLocale {
        return NSLocale(localeIdentifier: locale_code)
    }
    
    public init(display: String, key: String, shortDisplay: String, locale_code: String) {
        self.display = display
        self.key = key
        self.shortDisplay = shortDisplay
        self.locale_code = locale_code
    }
}

/**
 Global Language Controller Singleton
 
 Update langList for all support languages.
 
 Update defaultLangKey as System Default Langauge.
 
 Update selectedIndex as user prefer langauge.
 */
public class flLanguageController {
    public static let sharedService = flLanguageController()
    public static let systemLanguage = flLanguageData(display: "English", key: "en", shortDisplay: "EN", locale_code: "en_US")
    public static var currentLanguage: flLanguageData { return flLanguageController.sharedService.currentLanguage ?? flLanguageController.systemLanguage }
    
    /// English: flLanguageData(display: "English", key: "en", shortDisplay: "EN", locale_code: "en_US")
    ///
    /// Thai: flLanguageData(display: "Thai", key: "th", shortDisplay: "TH", locale_code: "th_TH")
    public var langList: [flLanguageData] = [flLanguageController.systemLanguage] {
        willSet {
            // update selected index for new list
            if let currentKey = currentKey {
                // find new index
                for (i, lang) in newValue.enumerate() {
                    if lang.key == currentKey  {
                        selectedIndex = i
                        return
                    }
                }
            }
            
            // 0 if not found the key in new list
            selectedIndex = 0
        }
        didSet { flLanguageController.updateCacheAndNotify() }
    }
    
    // System Default Langauge
    public var defaultLangKey = "en" { didSet { flLanguageController.updateCacheAndNotify() } }
    
    // User Prefer Lanaguage
    public var selectedIndex = 0 { didSet { flLanguageController.updateCacheAndNotify() } }
}

//MARK: Getter
extension flLanguageController {
    public var currentLanguage: flLanguageData? {
        return selectedIndex < langList.count ? langList[selectedIndex] : nil
    }
    
    public var currentKey: String? {
        return currentLanguage?.key
    }
    
    public var currentDisplay: String? {
        return currentLanguage?.display
    }
    
    public var currentShortDisplay: String? {
        return currentLanguage?.shortDisplay
    }
    
    var keySuffix: String {
        guard let key = currentKey else { return "" }
        if key == "" || key == defaultLangKey {
            return ""
        } else {
            return "_" + key
        }
    }
    
    public func getLangListDisplayText() -> [String] {
        return langList.map { $0.display ?? "" }
    }
}

// Translate String-base key to tuple key
extension flLanguageController {
    public static func prepareLanguageList(languageList: [[String: String]]) throws -> [flLanguageData] {
        return try languageList.map { language in
            
            // Parsing
            guard let display = language["display"],
                key = language["key"],
                short_display = language["short_display"] else { throw NSError(domain: "Parsing Error", code: -1, userInfo: nil) }
            
            // Backward Compatiblity for Locale
            let locale: String
            if let localeValue = language["locale"] {
                locale = localeValue
            } else {
                switch key {
                case "en": locale = "en_US"
                case "th": locale = "th_TH"
                default: locale = "en_US"
                }
            }
            
            return flLanguageData(display: display, key: key, shortDisplay: short_display, locale_code: locale)
        }
    }
}

//MARK: Cache key suffix
extension flLanguageController {
    public static var cacheKeySuffix = ""
    static var cacheKey = "en"
    static func updateCacheAndNotify() {
        let isChange = cacheKeySuffix != sharedService.keySuffix || cacheKey != sharedService.currentKey
        cacheKeySuffix = sharedService.keySuffix
        cacheKey = sharedService.currentKey ?? "en"
        if isChange {
            NSNotificationCenter.defaultCenter().postNotificationName(LANGUAGE_CHANGE_NOTIFY,
            object:cacheKey)
        }
    }
}
