//
//  NSDate+TimeFormat.swift
//  Dining
//
//  Created by Nattapon Nimakul on 8/26/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

//MARK: TimeFormat
extension NSDate {
    public func hourMinString() -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour , .Minute], fromDate:self)
        let hour = components.hour
        let minute = components.minute
        
        return String(format:"%02ld:%02ld", hour, minute)
    }
    
    public func dateString() -> String { return toString(dateFormat: "dd-MM-yyyy HH:mm") }
    public func dateStringPAM() -> String { return toString(dateFormat: "dd-MM-yyyy h:mm a") }
    public func timeString() -> String { return toString(dateFormat: "HH:mm") }
    public func timeStringPAM() -> String { return toString(dateFormat: "h:mm a") }
    
    public func isSameDay(aDate: NSDate) -> Bool {
        let calendarUnits: NSCalendarUnit = [.Era, .Year, .Month, .Day]
        let aDay = NSCalendar.currentCalendar().components(calendarUnits, fromDate:aDate)
        let bDay = NSCalendar.currentCalendar().components(calendarUnits, fromDate:self)
        
        if aDay.day == bDay.day &&
            aDay.month == bDay.month &&
            aDay.year == bDay.year &&
            aDay.era == bDay.era {
            return true
        } else {
            return false
        }
    }
}

//MARK: Myroom
extension NSDate {
    public func shortDatetime(language language: flLanguageData = flLanguageController.currentLanguage) -> String {
        let today = NSDate()
        let yesterday = NSDate(timeIntervalSinceNow:-3600*24*1)
        let tomorrow = NSDate(timeIntervalSinceNow:+3600*24*1)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = language.locale

        // hh:mm AM/PM for today
        if isSameDay(today) {
            dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
            
            return dateFormatter.stringFromDate(self)
            
            // Yesterday
        } else if isSameDay(yesterday) {
            return localize("Yesterday", languageKey: language.key)
            
            // Tomorrow
        } else if isSameDay(tomorrow) {
            dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
            
            return localize("Tomorrow", languageKey: language.key) + " \(dateFormatter.stringFromDate(self))"
        }
        
        // Monday, Tuesday, Wednesday for 2-6 day ago
        for i in 2...6 {
            if isSameDay(NSDate(timeIntervalSinceNow:NSTimeInterval(-3600*24*i))) {
                dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
                
                return dateFormatter.stringFromDate(self)
            }
        }
        
        // mm/dd/yy for etc
        dateFormatter.setLocalizedDateFormatFromTemplate("d/M/yy")
        
        return dateFormatter.stringFromDate(self)
    }
    
    // mm/dd/yy for etc
    public func longDateTime() -> String { return toString(dateFormat: "MMMM d, yyyy, h:mm a") }
    public func dateMonthNameYear() -> String { return toString(dateFormat: "dd MMMM yyyy") }
    public func dateDayMonthYearAndTimeShort() -> String { return toString(dateFormat: "dd-MMM-yyyy h:mma") }
    
    public func dateForJson() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ssZZZZZ"
        dateFormatter.locale = flLanguageController.systemLanguage.locale
        let strDate = dateFormatter.stringFromDate(self)
        
        return strDate
    }
    
    public static func dateFromJsonString(text: String) -> NSDate? {
        let formatSupports = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ", // 2016-06-18T11:46:14.278+07:00
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ", // 2016-06-18T11:46:14+07:00
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", // 2016-06-18T11:46:14.281Z
            "yyyy-MM-dd HH:mm:ssZZZZZ", // 2016-06-18 11:46:14+07:00
        ]
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = flLanguageController.systemLanguage.locale
        
        // Try each format
        for dateFormat in formatSupports {
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.dateFromString(text) {
                return date
            }
        }
        
        return nil
    }
    
    public static func dateMonthNameYearParser(text: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = flLanguageController.systemLanguage.locale
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter.dateFromString(text)
    }
}

//MARK: Weather
extension NSDate {
    public func weatherTime() -> String { return toString(dateFormat: "hh:mm a") }
    public func weatherDate() -> String { return toString(dateFormat: "dd / MM / yyyy") }
}

//MARK: Adjust Date Time
extension NSDate {
    public func adjustDateToFitInterval(interval: Int, minimumOperatingTime operatingTime: Int) -> NSDate {
        var date = self.copy() as! NSDate
        
        // Minimum Operating Time
        date = date.dateByAddingTimeInterval(NSTimeInterval(60*operatingTime))
        
        // Adjust to fit nearest next Time Interval
        var time = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate:date)
        
        // To next minute
        if 0 != time.second {
            date = date.dateByAddingTimeInterval(NSTimeInterval(60 - time.second))
            time = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate:date)
        }
        
        // To next interval minute
        let pass = time.minute % interval
        if 0 != pass {
            date = date.dateByAddingTimeInterval(NSTimeInterval(60*(interval - pass)))
        }
        
        return date
    }
}

//MARK: Manipulate
extension NSDate {
    public func todayDate() -> NSDate {
        // Get today year-month-day
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = flLanguageController.systemLanguage.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.stringFromDate(NSDate())
        
        // Get output time
        dateFormatter.dateFormat = " HH:mm:ss ZZ"
        let time = dateFormatter.stringFromDate(self)
        
        // Set year-month-day to target time
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZ"
        guard let output = dateFormatter.dateFromString(today + time) else {
            flLog.error("todayDate() failed, can not generate output for \(self)")
            return self
        }
        return output
    }
    
    public static func todayDateForHourAndMinute(hourAndMinute: String) -> NSDate? {
        let dateFormatString = "yyyy-MM-dd \(hourAndMinute):00 ZZ"
        
        // Get today year-month-day
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = flLanguageController.systemLanguage.locale
        dateFormatter.dateFormat = dateFormatString
        let today = dateFormatter.stringFromDate(NSDate())
        
        // Set year-month-day to target time
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZ"
        return dateFormatter.dateFromString(today)
    }
}

//MARK: Adjust
extension NSDate {
    public func removeNanoSecond() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = flLanguageController.systemLanguage.locale
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZ"
        guard let output = dateFormatter.dateFromString(dateFormatter.stringFromDate(self)) else {
            flLog.error("removeNanoSecond failed, cannot generate output for \(self)")
            return self
        }
        return output
    }
}

//MARK: Helper
extension NSDate {
    public func toString(dateStyle dateStyle: NSDateFormatterStyle = .NoStyle, timeStyle: NSDateFormatterStyle = .NoStyle, language: flLanguageData = flLanguageController.currentLanguage) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.locale = language.locale
        
        return dateFormatter.stringFromDate(self)
    }
    
    public func toString(dateFormat dateFormat: String, language: flLanguageData = flLanguageController.currentLanguage) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat)
        dateFormatter.locale = language.locale
        
        return dateFormatter.stringFromDate(self)
    }
}
