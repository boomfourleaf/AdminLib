//
//  DiningMenuAndConfigurationSyncer.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/1/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public class DiningMenuAndConfigurationSyncer: ContentSyncer {
    public static let MENU_DID_UPDATE_NOTIFY = "DINING_MENU_AND_CONFIGURATION_SYNCER_MENU_DID_UPDATE_NOTIFY"
    public static let MENU_DOWNLOAD_PERCENT = "DINING_MENU_AND_CONFIGURATION_SYNCER_MENU_DOWNLOAD_PERCENT"
    public static let shareObject = DiningMenuAndConfigurationSyncer()
    
    var dataArr: [AnyObject]?
    var groupOptions: ObjcDictionary?
    
    // This API is not Thread safe, so it should be used once App launched
    public func manualGetContent() -> (hash: String, dataArr: [AnyObject]?, groupOptions: ObjcDictionary?) {
        return (updateHash, dataArr, groupOptions)
    }
    
    /// Step 1 download Content
    public override func downloadFile() {
        // If version have changed, then clear update hash
        let isVersionHaveChange = flVersionController.isVerionChanged()
        if isVersionHaveChange {
            flLog.info("detech version have changed, then clear update hash 22")
            self.updateHash = ""
        }
        
        flServiceController.sharedService.diningMainApi.parameters = [self.updateHash == "" ? "-" : self.updateHash]
        
        // Show Porgress for Initial Loading Content
        if nil == self.dataArr {
            flServiceController.sharedService.diningMainApi.delegate = self
        } else {
            flServiceController.sharedService.diningMainApi.delegate = nil
        }
        
        flServiceController.sharedService.diningMainApi.run()
        
        // Update to new data version success
        if isVersionHaveChange {
            flLog.info("Update to new data version success")
            flVersionController.markAsContentIsUpToDate()
        }
    }
    
    //TODO: DINING_RESTAURANT_MODE_SHIFT_LIST
    //TODO: API_ORDER_CONFIG
    // Step 2 store data into memory
    
    
    /// Step 2 Get Content
    public override func getContent() -> JSON? {
        if let dataDict = flServiceController.sharedService.getDining("1") {
            return JSON(dataDict)
        } else {
            return nil
        }
    }
    
    /// Step 3 Update Content if Changed
    public override func updateContentIfChanged(dataJson: JSON) {
        self.dataArr = dataJson[API_ROOT_DATAS].arrayObject
        self.groupOptions = dataJson[API_ROOT_GROUP_OPTION_LIST].dictionaryObject
        
        // Restaurant Mode
        let restaurantMode = dataJson[API_DINING_RESTAURANT_MODE]
        flRestaurantConfigure.shareObject.maxSplitBill = restaurantMode[DINING_RESTAURANT_MODE_MAX_SPLIT_BILL].int ?? 25
        flRestaurantConfigure.shareObject.zones = restaurantMode[DINING_RESTAURANT_MODE_TABLE].arrayObject as? [ObjcDictionary]
        //                    flRestaurantConfigure.shareObject.updateShifts(restaurantMode[DINING_RESTAURANT_MODE_SHIFT_LIST].arrayObject)
        
        let tableInputMode: TableInputMode
        switch restaurantMode[DINING_RESTAURANT_MODE_TABLE_INPUT_MODE].stringValue {
        case DINING_RESTAURANT_MODE_TABLE_INPUT_MODE_TABLE_SCROLL: tableInputMode = .TableScroll
        case DINING_RESTAURANT_MODE_TABLE_INPUT_MODE_TABLE_GRID: tableInputMode = .TableGrid
        case DINING_RESTAURANT_MODE_TABLE_INPUT_MODE_TEXTINPUT: tableInputMode = .TextInput
        default: tableInputMode = .TableScroll
        }
        flRestaurantConfigure.shareObject.tableInputMode = tableInputMode
        
        // Staff List
        flStaffListConfigure.shareObject.staffs = dataJson[API_ROOT_STAFF_LIST].arrayObject as? [ObjcDictionary]
        
        // Order Configure
        flVC.orderController()?.orderConfig = dataJson[API_ORDER_CONFIG].dictionaryObject
        
        self.updateDiscountFilters(dataJson[API_DISCOUNT_FILTER])
        self.processDiningMode()
        flGlobal.setInvoiceConfigure(dataJson[API_INVOICE_CONFIG].dictionaryObjectValue)
        self.updatePrinterServices(restaurantMode.dictionaryObject)
        
        // Discount Percent Label Style
        if let discountPercentLabelStyle = flRestaurantConfigure.DiscountPercentLabelStyle(rawValue: restaurantMode[DINING_RESTAURANT_MODE_DISCOUNT_PERCENT_LABEL_STYLE].stringValue) {
            flRestaurantConfigure.shareObject.discountPercentLabelStyle = discountPercentLabelStyle
        }
    }

    public override func contentDidUpdateWithHash(hash: String) {
        guard let dataArrValue = dataArr, groupOptionsValue = groupOptions else { return }
        let userInfo: ObjcDictionary = ["hash": hash, "dataArr": dataArrValue, "groupOptions": groupOptionsValue]
        NSNotificationCenter.defaultCenter().postNotificationName(DiningMenuAndConfigurationSyncer.MENU_DID_UPDATE_NOTIFY, object: self, userInfo:userInfo)
    }
}

extension DiningMenuAndConfigurationSyncer {
    private func updateDiscountFilters(filters: JSON) {
        var newFilters = [DiscountFilter]()
        for filter in filters.arrayValue {
            if let name = filter["name"].string,
                let id = filter["id"].int,
                let on = filter["default"].bool {
                newFilters.append(DiscountFilter(name: name, id: id, on: on))
            }
        }
        DiscountFilterController.defaultFilters = newFilters
    }
    
    private func processDiningMode() {
        var shouldRelaunchApp = false
        
        // Update Dining Mode (Normal/Restaurant)
        let isRestaurantMode: Bool
        if let zoenCount = flRestaurantConfigure.shareObject.zones?.count
            where zoenCount != 0 {
            isRestaurantMode = true
        } else {
            isRestaurantMode = false
        }
        
        let mode: DiningMode = isRestaurantMode ? .RESTAURANT : .NORMAL
        // Mode Changing
        if DiningMenuAndConfigurationSyncer.diningMode() != mode {
            shouldRelaunchApp = true
        }
        
        
        flPersistData.setObj(mode.rawValue, forKey:DINING_MODE_KEY)
        
        if shouldRelaunchApp {
            exit(0)
        }
    }
    
    //TODO: PRINTER_SERVICES_LIST_DID_UPDATE
    private func updatePrinterServices(dict: ObjcDictionary?) {
        // Update Printer Services
        if let dictValue = dict {
            let dictJson = JSON(dictValue)
            let serverConfigure = flServerConfigure.shareObject
            let oldPrinterNames = serverConfigure.printServiceNames
            if let printerServices = dictJson[DINING_RESTAURANT_MODE_PRINTER_SERVICES].arrayObject {
                if printerServices.count > 0 {
                    serverConfigure.printServiceEnable = true
                    if let printServiceNames = dictJson[DINING_RESTAURANT_MODE_PRINTER_SERVICES].arrayObject as? [String] {
                        serverConfigure.printServiceNames = printServiceNames
                    }
                } else {
                    serverConfigure.printServiceEnable = false
                    serverConfigure.printServiceNames = []
                }
            }
            if oldPrinterNames != serverConfigure.printServiceNames {
                flLog.info("PRINTER_SERVICES_LIST_DID_UPDATE \(serverConfigure.printServiceNames)")
//                NSNotificationCenter.defaultCenter().postNotificationName(PRINTER_SERVICES_LIST_DID_UPDATE, object: nil)
            }
            
            serverConfigure.saveToPersistance()
        }
    }
}

//MARK: Helper
extension DiningMenuAndConfigurationSyncer {
    public enum DiningMode: String {
        case NORMAL, RESTAURANT
    }
    
    public static func diningMode() -> DiningMode {
        return (flPersistData.objForKey(DINING_MODE_KEY) as? String).flatMap {
            DiningMode(rawValue: $0)
        } ?? .NORMAL
    }
}

extension DiningMenuAndConfigurationSyncer: flApiDelegate {
    @objc public func updateProgress(percent: Int) {
        let userInfo: ObjcDictionary = ["percent": percent]
        NSNotificationCenter.defaultCenter().postNotificationName(DiningMenuAndConfigurationSyncer.MENU_DOWNLOAD_PERCENT, object: self, userInfo:userInfo)
    }
}
