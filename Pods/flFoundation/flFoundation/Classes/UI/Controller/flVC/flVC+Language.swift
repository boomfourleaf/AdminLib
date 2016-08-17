//
//  flVC+Language.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension flVC {
    public func setLangList(langList: [flLanguageData], withDefault key: String) {
        let langCon = flLanguageController.sharedService
        langCon.langList = langList
        langCon.defaultLangKey = key
    }
    
    @available(iOS, deprecated=9.0, message="Use flLanguageController.sharedService.langList instead")
    public func getLangList() -> [flLanguageData] {
        return flLanguageController.sharedService.langList
    }
    
    @available(iOS, deprecated=9.0, message="Use flLanguageController.sharedService.getLangListDisplayText() instead")
    public func getLangListDisplayText() -> [String] {
        return flLanguageController.sharedService.getLangListDisplayText()
    }
    
    @available(iOS, deprecated=9.0, message="Use flLanguageController.sharedService.currentLanguage instead")
    public func currentLanguage() -> flLanguageData? {
        return flLanguageController.sharedService.currentLanguage
    }
    
    @available(iOS, deprecated=9.0, message="Use flLanguageController.sharedService.selectedIndex instead")
    public func currentLangIndex() -> Int {
        return flLanguageController.sharedService.selectedIndex
    }
}

