//
//  AppsoLogManager.swift
//  Dining
//
//  Created by Nattapon Nimakul on 7/27/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public final class AppsoLogManager: NSObject {
    var debug = true
    
    public static let sharedService = AppsoLogManager()
}

extension AppsoLogManager {
    public class func writeLog(line: String) {
        AppsoLogManager.sharedService.writeLog(line)
    }
    
    public func readLog() -> String {
        let documentsDirectory = flFile.mainDocument()
        let filePath = (documentsDirectory as NSString).stringByAppendingPathComponent(Config.LOG_TXT)
        return AppsoFileManager.readTextAtPath(filePath)
    }
    
    public func writeLog(line: String) {
        let documentsDirectory = flFile.mainDocument()
        let filePath = (documentsDirectory as NSString).stringByAppendingPathComponent(Config.LOG_TXT)
        let currentDate = getCurrentDate()
        
        AppsoFileManager.appendString("\r\n\(currentDate): \(line)", atPath:filePath)
    }
    
    public func readLogStat() -> String {
        let documentsDirectory = flFile.mainDocument()
        let filePath = (documentsDirectory as NSString).stringByAppendingPathComponent(Config.LOG_STAT_TXT)
        
        return AppsoFileManager.readTextAtPath(filePath)

    }
    
    public func writeLogStat(line: String) {
        let documentsDirectory = flFile.mainDocument()
        let filePath = (documentsDirectory as NSString).stringByAppendingPathComponent(Config.LOG_STAT_TXT)
        let currentDate = getCurrentDateStat()
        
        AppsoFileManager.appendString("\r\n\(currentDate)|\(line)", atPath:filePath)
    }
    
    public func clearLogStat() {
        let documentsDirectory = flFile.mainDocument()
        let filePath = (documentsDirectory as NSString).stringByAppendingPathComponent(Config.LOG_STAT_TXT)
        
        AppsoFileManager.deleteAtPath(filePath)
    }
}

extension AppsoLogManager {
    private func getCurrentDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" //2012-01-03 12:22

        return dateFormatter.stringFromDate(NSDate())
    }
    
    private func getCurrentDateStat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmss"
        
        return dateFormatter.stringFromDate(NSDate())
    }
}

//MARK: Config
extension AppsoLogManager {
    struct Config {
        static let LOG_TXT = "log.txt"
        static let LOG_STAT_TXT = "log_stat.txt"
    }
}
