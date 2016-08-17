//
//  flVC.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/10/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

public class flVC: UIViewController {
    public var service: flServiceController { return flServiceController.sharedService }
    public var updateHash = ""
    public var lastDisplayUpdateHash = ""
    public var themeUpdateHash = ""
    public var lastDisplaythemeUpdateHash = ""
    public var autoUpdateInterval = 10
    public var langUpdateHash = ""
    public var lastDisplaylangUpdateHash = ""
    public var langSuffix = ""
    public var autoUpdateEnable = false
    public var languageAutoUpdateEnable = false
    
    public var autoUpdateTimer: NSTimer?
    var languageAutoUpdateTimer: NSTimer?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(appHasBecomeActive),
                                                         name:UIApplicationDidBecomeActiveNotification,
                                                         object:nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension flVC {

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        flLog.info("1")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        readFile()
        languageReadFile()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        background{ self.downloadFile() }
        initData()
        
        background{ self.languageDownloadFile() }
        
        if autoUpdateEnable {
            startTimerForAutoUpdate()
        }
        
        if languageAutoUpdateEnable {
            languageStartTimerForAutoUpdate()
        }
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if autoUpdateEnable {
            stopTimerForAutoUpdate()
        }
        
        if languageAutoUpdateEnable {
            languageStopTimerForAutoUpdate()
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        background{ self.logThisView() }
    }
    
    //MARK: - Flow
    // Step 1
    public func downloadFile() {
        
    }
    
    // Step 2
    public func readFile() {
        
    }
    
    // Step 3
    public func initData() {
        
    }
    
    // THEME - Step 1
    public func themeDownloadFile() {
        
    }
    
    // THEME - Step 2
    public func themeReadFile() {
        
    }
    
    // THEME - Step 3
    public func themeInitData() {
        
    }
    
    // LANGUAGE - Step 1
    public func languageDownloadFile() {
        
    }
    
    // LANGUAGE - Step
    public func languageReadFile() {
        
    }
    
    // LANGUAGE - Step 3
    public func languageInitData(langChange: NSNumber?) {
        
    }
    
    // MARK: - Multitasking Notification
    public func appHasBecomeActive() {
        background {
            self.downloadFile()
        }
    }
    
    //MARK: - Interface Orientation
    public func deviceOrientation() -> FLDeviceOrientation {
        return flDevice.deviceOrientationForView(view)
    }
    
    //MARK: - Log
    public func logThisView() {
//        let name = NSStringFromClass(self.classForCoder).componentsSeparatedByString(".").last!
//        flLogController.logOpenView(name)
    }
    
    public func isRestaurantModeWithTabBar() -> Bool {
        switch DiningMenuAndConfigurationSyncer.diningMode() {
        case .RESTAURANT: return true
        case .NORMAL: return false
        }
    }
}
