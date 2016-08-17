//
//  flVC+Date.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension flVC {
    //MARK: - Date Time
    public func operationTime(begin: NSDate?, End end: NSDate?) -> String? {
        if let uwpBegin = begin {
            if let uwpEnd = end {
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .ShortStyle
                
                let beginTxt = dateFormatter.stringFromDate(uwpBegin)
                let endTxt = dateFormatter.stringFromDate(uwpEnd)
                
                return "\(beginTxt) - \(endTxt)"
            }
        }
        return ""
    }
    
    public func operationTime(times: NSArray?) -> String? {
        if let uwpTimes = times as? [[NSDate]] {
            var outputs = [String]()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .ShortStyle
            
            for beginEnd in uwpTimes {
                if beginEnd.count == 2 {
                    let begin = beginEnd[0]
                    let end = beginEnd[1]
                    
                    let beginTxt = dateFormatter.stringFromDate(begin)
                    let endTxt = dateFormatter.stringFromDate(end)
                    
                    outputs.append("\(beginTxt) - \(endTxt)")
                }
            }
            
            return outputs.joinWithSeparator(",\n")
        }
        return ""
    }
    
    public func dateAvailable(current: NSDate?, begin: NSDate!, end: NSDate!, withInterval interval: Int, enumerateObjectsUsingBlock block: (NSDate?, inout Bool)->()) {
        
        if begin == nil || end == nil {
            return
        }
        
        var myCurrent: NSDate! = current
        if myCurrent == nil {
            myCurrent = begin.copy() as! NSDate
        }
        
        // Remove current nano second
        while (true) {
            flLog.info("current( \(myCurrent) ) end( \(end) ) compare \(myCurrent?.compare(end))")
            
            let calendarComponents: NSCalendarUnit = [.Hour, .Minute, .Second, .Nanosecond]
            let currentTime = NSCalendar.currentCalendar().components(calendarComponents, fromDate: myCurrent)
            flLog.info("currentTime \(currentTime.nanosecond)")
            
            let endTime = NSCalendar.currentCalendar().components(calendarComponents, fromDate: end)
            flLog.info("endTime \(endTime.nanosecond)")
            
            // if current between begin and end (inclusive)
            if (myCurrent.compare(begin) == .OrderedDescending && myCurrent.compare(end) == .OrderedAscending) ||
                (myCurrent.compare(begin) == .OrderedSame) ||
                (myCurrent.compare(end) == .OrderedSame) {
                    flLog.info("current \(myCurrent), begin \(begin), end \(end)")
                    var shouldStop = false
                    block(myCurrent, &shouldStop)
                    if shouldStop {
                        return
                    }
            } else {
                break
            }
            myCurrent = myCurrent.dateByAddingTimeInterval( NSTimeInterval(interval * 60) )
        }
    }
    
    public func dateAvailableStrCurrent(current: NSDate?, begin: NSDate?, end: NSDate?, withInterval interval: Int, format: String?) -> [String]? {
        var dateStrs = [String]()
        let dateFormatter = NSDateFormatter()
        
        if format == "ampm" {
            dateFormatter.timeStyle = .ShortStyle
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        }
        
        dateAvailable(current, begin: begin, end: end, withInterval: interval) { (date, stop) -> () in
            if let uwpDate = date {
                dateStrs.append(dateFormatter.stringFromDate(uwpDate))
            } else {
                stop = true
            }
        }
        return dateStrs
    }
    
    public func dateAvailableStrBegin(begin: NSDate?, end: NSDate?, withInterval interval: Int, format: String?) -> [String]? {
        return dateAvailableStrCurrent(nil, begin: begin, end: end, withInterval: interval, format: format)
    }
    
    public func dateAvailableStrFromCurrentWithBegin(begin: NSDate?, end: NSDate?, withInterval interval: Int, format: String?) -> [String]? {
        var current = NSDate().adjustDateToFitInterval(interval, minimumOperatingTime: 0)
        current = current.removeNanoSecond()
        
        return dateAvailableStrCurrent(current, begin: begin, end: end, withInterval: interval, format: format)
    }
}
