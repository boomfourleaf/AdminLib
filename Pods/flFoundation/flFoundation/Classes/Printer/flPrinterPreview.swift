//
//  flPrinterPreview.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/5/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public final class flPrinterPreview: flPrinterRasterProtocol {
    public var lineMaxChar = 64
    public var lineWidth = 576
    public var printMode: PRINTER_PRINT_MODE = .RASTER
    public var vendor = "STAR"
    public var address = ""
    public var model = "STAR-TSP650II"
    
    public func openPrinter() -> PRINTER_STATUS { return .SUCCESS }
    public func closePrinter(showError: Bool) -> PRINTER_STATUS { return .SUCCESS }
    public func sendData() -> PRINTER_STATUS { return .SUCCESS }
    public func openCashDrawer() -> PRINTER_STATUS { return .SUCCESS }
    public func cutPaper(cutType: PRINTER_CUT) -> PRINTER_STATUS { return .SUCCESS }
    public func newBuilder() { }
    
    public lazy var imageCaches = [UIImage]()
    
    public init() {
        
    }
    
    // Image
    public func printImage(image: UIImage, atuoAdjust: Bool) -> PRINTER_STATUS {
        let imageToPrint = atuoAdjust ? prepareImageForPrint(image) : image
        imageCaches.append(imageToPrint)
        return .SUCCESS
    }
    
    public func exportToImage() -> UIImage {
        return flPrinterPreview.compositeImages(imageCaches)
    }
}

extension flPrinterPreview {
    public func printTexts(leftText: String, rightText: String?=nil, font: String?=nil, bold: Bool=false, small: Bool=false, underline: Bool=false, center: Bool=false) {
        // Command
        let command: String
        switch (rightText, center) {
        case (_, true): command = "CenterText"
        case (nil, _):  command = "LeftText"
        default: command = "DoubleText"
        }
        
        // Text
        let texts = nil != rightText ? [leftText, rightText!] : [leftText]
        
        // Option
        var options = [String]()
        if bold {
            options += ["B2"]
        }
        if let fontValue = font {
            options += [fontValue]
        }
        if underline {
            options += ["U"]
        }
        if small {
            options += ["S"]
        }
        
        printCommand(["command": command, "value": ["text": texts, "option": options]])
    }
    
    public func printHeadName(text: String) {
        printTexts(text, font: "H5", bold: true, center: true)
    }
    
    public func printUnderLine() {
        printTexts(" ", rightText: " ", font: "H16", underline: true)
    }
    
    public func printBigText(leftText: String, rightText: String?=nil) {
        printTexts(leftText, rightText: rightText, font: "H5", bold: true)
    }
    public func printHeaderText(leftText: String, rightText: String?=nil) {
        printTexts(leftText, rightText: rightText, font: "H7")
    }
    
    public func printNormalText(leftText: String, rightText: String?=nil, options: [String]=["H9"]) {
        printTexts(leftText, rightText: rightText, font: "H9")
    }
    
    public func printNormalTextSmaller(leftText: String, rightText: String?=nil, underline: Bool=false) {
        printTexts(leftText, rightText: rightText, underline: underline)
    }
    
    public func printSmallText(leftText: String, rightText: String?=nil, center: Bool=false) {
        printTexts(leftText, rightText: rightText, small: true, center: center)
    }
    
    public func feed(feed: Int) {
        printCommand(["command": "Feed", "value": ["text": ["\(feed)"], "option": []]])
    }
}

