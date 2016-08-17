//
//  AppsoFileManager.swift
//  Dining
//
//  Created by Nattapon Nimakul on 7/26/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class AppsoFileManager: NSObject {
    public static func isExist(path: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    public static func readTextAtPath(path: String) -> String {
        do {
            return try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        } catch {
            flLog.error("File Management Error when reading text at path \(path)")
            return ""
        }
    }
    
    public static func readDataAtPath(path: String) -> NSData? {
        return NSData(contentsOfFile: path)
    }
    
    public static func writeText(text: String, atPath path: String) {
        do {
            try text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            flLog.error("File Management Error when writing text at path \(path)")
        }
    }

    public static func writeData(data: NSData, atPath path: String) {
        data.writeToFile(path, atomically: true)
    }
    
    public static func appendString(text: String,  atPath path: String) {
        // Create if now exist
        if !isExist(path) {
            writeText("", atPath: path)
        }
        
        // Append
        if let fileHandler = NSFileHandle(forUpdatingAtPath: path),
            data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            fileHandler.seekToEndOfFile()
            fileHandler.writeData(data)
            fileHandler.closeFile()
        }
    }
    
    public static func deleteAtPath(path: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
            flLog.error("File Management Error when deleting at pat \(path)")
        }
    }
}
