//
//  flPrinterStar.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/20/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

class flPrinterStar: flPrinterRasterProtocol {
    var lineMaxChar = 1
    var lineWidth = 1
    var printMode: PRINTER_PRINT_MODE = .RASTER
    var vendor = "STAR"
    var address = ""
    var model = ""
    
    private struct Config {
        static let PORT_STANDARD = "Standard"
        static let PORT_PORTABLE = "Portable"
        static let PORT_MPOP = "mPOP"
    }
    
    
    var portName: String { return address }
    var portSettings: String {
        switch model {
            case STAR_SMS230I, STAR_SML200: return Config.PORT_PORTABLE
            case STAR_MPOP: return Config.PORT_MPOP
            default: return Config.PORT_STANDARD
        }
    }
    var compressionEnable = true
    lazy var imageCaches = [UIImage]()
    
    var timeBegin = NSDate()
    var connectionTimeout: UInt32 {
        // For Star TCP:xx and BLE:xx conneciton can be take too long time if can't connect, it will make other star printers waiting for global thread lock.
        // Workaround: Decrease connection timeout to make timeout ealry and other star pritners can do their works.
        if portName.hasPrefix("TCP:") || portName.hasPrefix("BLE:") {
            return 4 * 1000 // 4 sec
        } else {
            return 30 * 1000 // 30 sec
        }
    }
    
    lazy var printer = PrinterFunctions()    
    
    func printImage(image: UIImage, atuoAdjust: Bool) -> PRINTER_STATUS {
        let imageToPrint = atuoAdjust ? prepareImageForPrint(image) : image
        imageCaches.append(imageToPrint)
        return .SUCCESS
    }
    
    func openCashDrawer() -> PRINTER_STATUS {
        return printer.openCashDrawerNumber(1)
    }
    
    //TODO: Implement
    /// For normal print, it will automatically cut on sendData()
    func cutPaper(cutType: PRINTER_CUT) -> PRINTER_STATUS {
        
        return .SUCCESS
    }
    
    func openPrinter() -> PRINTER_STATUS {
        timeBegin = NSDate()
        let output = printer.openPrinterWithPortName(portName, portSettings: portSettings, timeoutMillis: connectionTimeout)
        return output
    }
    
    func closePrinter(showError: Bool) -> PRINTER_STATUS {
        let output = printer.closePrinter()
        return output
    }

    func newBuilder() {
        // Do nothing
    }
    
    func sendData() -> PRINTER_STATUS {
        let images = Config.PORT_PORTABLE == portSettings ? [flPrinterStar.compositeImages(imageCaches)] : imageCaches
        let output = printer.PrintImages(images,
            portSettings: portSettings,
            maxWidth: Int32(lineWidth),
            compressionEnable: compressionEnable,
            withDrawerKick: false,
            pageEndMode: RasPageEndMode_FeedAndFullCut)
        return output
    }


// Time Measure

    func printTimeTaking() {
        let interval = NSDate().timeIntervalSinceDate(timeBegin)
        flLog.info("time: \(interval)")
    }
}


