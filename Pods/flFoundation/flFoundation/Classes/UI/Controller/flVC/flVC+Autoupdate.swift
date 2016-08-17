//
//  flVC+Autoupdate.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension flVC {
    //MARK: - Auto Timer Update
    public func startTimerForAutoUpdate() {
        if autoUpdateTimer == nil {
            autoUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(autoUpdateInterval), target: self, selector: #selector(flVC.fetchUpdateInfo(_:)), userInfo: nil, repeats: true)
        }
    }
    
    public func stopTimerForAutoUpdate() {
        autoUpdateTimer?.invalidate()
        autoUpdateTimer = nil
    }
    
    public func fetchUpdateInfo(timer: NSTimer?) {
        background{ self.downloadFile() }
    }
    
    // Langauge
    public func languageStartTimerForAutoUpdate() {
        if languageAutoUpdateTimer == nil {
            languageAutoUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(autoUpdateInterval), target: self, selector: #selector(flVC.languageFetchUpdateInfo(_:)), userInfo: nil, repeats: true)
        }
    }
    
    public func languageStopTimerForAutoUpdate() {
        languageAutoUpdateTimer?.invalidate()
        languageAutoUpdateTimer = nil
    }
    
    public func languageFetchUpdateInfo(timer: NSTimer?) {
        background{ self.languageDownloadFile() }
    }
}
