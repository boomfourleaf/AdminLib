//
//  flPrinterEpson.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/2/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

class flPrinterEpson: flPrinterProtocol {
    var lineMaxChar = 1
    var lineWidth = 1
    var isOpen = false
    var printMode: PRINTER_PRINT_MODE = .LINE
    var vendor = "EPSON"
    var address = ""
    var model = ""
    
    private lazy var esPrinterLock = NSObject()
    private var _esPrinter: EposPrint?
    var esPrinter: EposPrint?  {
        set {
            synced(esPrinterLock) {
                self._esPrinter = newValue
            }
        }
        get {
            // Create if Needed
            var output: EposPrint?
            synced(esPrinterLock) {
                if nil == self._esPrinter {
                    self._esPrinter = EposPrint()
                }
                output = self._esPrinter
            }
            return output
        }
    }
    var builder: EposBuilder?

//MARK: Connection
    func openPrinter() -> PRINTER_STATUS {
        if let printer = esPrinter {
            //    [printer setPowerOffEventCallback:@selector(onPowerOff:) Target:self];
            //    [printer setStatusChangeEventCallback:@selector(onStatusChange:Status:) Target:self];
            //    int result = [printer openPrinter:EPOS_OC_DEVTYPE_TCP DeviceName:self.ip Enabled:YES Interval:EPSON_INTERVAL];
            let result = printer.openPrinter(Int32(EPOS_OC_DEVTYPE_TCP.rawValue), deviceName:address)
            if result != Int32(EPOS_OC_SUCCESS.rawValue) {
                return .ERR_CONNECT
            }
            //    [printer setPowerOffEventCallback:nil Target:nil];
            //    [printer closePrinter];
            
            isOpen = true
            
            return .SUCCESS
        }
        else {
            return .ERR_CONNECT
        }
    }
    
    //- (void)onPowerOff:(NSObject*)obj {
    //    TTDERROR(@"power off");
    //}
    
    //- (void)onStatusChange:(NSString *)deviceName Status:(NSNumber *)status {
    //    TTDERROR(@"devicename %@ status:%@", deviceName, status);
    //}
    
    func closePrinter(showError: Bool) -> PRINTER_STATUS {
        isOpen = false
        if let printer = esPrinter {
            let result = printer.closePrinter()
            if result != Int32(EPOS_OC_SUCCESS.rawValue) {
                if showError {
                    ShowMsg.showExceptionEpos(result, method:"closePrinter", detail:"vendor:\(vendor) address:\(address) model:\(model)")
                }
                return epsonToPrinterStatus(result)
            }
            esPrinter = nil;
        }
        else  {
            return .ERR_CONNECT
        }
        
        return .SUCCESS
    }
    
    func closePrinter() -> PRINTER_STATUS {
        return closePrinter(true)
    }
    
    func newBuilder() {
        //create builder
        let builder = EposBuilder(printerModel:model, lang:Int32(EPSON_LANG.rawValue))
        if builder == nil {
            flLog.info("newBuilder error")
        }
        
        self.builder = builder
    }

//MARK: Operation
    func clearBuilderBuffer() {
        //remove builder
        builder?.clearCommandBuffer()
    }
    
    func sendData() -> PRINTER_STATUS {
        //send builder data
        var status: UInt = 0
        var battery: UInt = 0
        
        if let printer = esPrinter {
            let result = printer.sendData(builder, timeout:EPSON_SEND_TIMEOUT, status:&status, battery:&battery)
            if result != Int32(EPOS_OC_SUCCESS.rawValue) {
                ShowMsg.showExceptionEpos(result, method:"sendData", detail:"vendor:\(vendor) address:\(address) model:\(model)")
                return epsonToPrinterStatus(result)
            }
            
            //remove builder
            builder?.clearCommandBuffer()
            
            return .SUCCESS
        } else {
            return .ERR_CONNECT
        }
    }
    
    
    
    func openCashDrawer() -> PRINTER_STATUS {
        guard let builderValue = builder else { return .ERR_FAILURE }

        //add command
        let pulse: Int32 = 1
        let time: Int32 = 1
        let result = builderValue.addPulse(pulse, time:time)
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"openCashDrawer", detail:"pulse:\(pulse) time:\(time)")
            return epsonToPrinterStatus(result)
        }
        
        return .SUCCESS
    }
    
    func feed(feed: Int) -> PRINTER_STATUS {
        guard let builderValue = builder else { return .ERR_FAILURE }
        //add command
        let result = builderValue.addFeedUnit(feed/10)
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addFeedUnit", detail:"\(feed/10)")
            return epsonToPrinterStatus(result)
        }
        
        return .SUCCESS
    }
    
    func cutPaper(cutType: PRINTER_CUT = .FEED) -> PRINTER_STATUS {
        guard let builderValue = builder else { return .ERR_FAILURE }
        //add command
        let result = builderValue.addCut(toEpsonCutType(cutType))
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addCut", detail:"\(cutType)")
            return epsonToPrinterStatus(result)
        }
        
        return .SUCCESS
    }

//MARK: Text Mode 
    func printTextForTextMode(textInput: String, align: PRINTER_ALIGN, lineSpace: Int, feed: Int, underLine isUnderLine: Bool, bold isBold: Bool, newLine: Bool) -> PRINTER_STATUS {
        guard let builderValue = builder else { return .ERR_FAILURE }
        
        var text = textInput
        
        //add command
        var result = builderValue.addTextFont(Int32(EPSON_FONT.rawValue))
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addTextFont", detail:"\(EPSON_FONT)")
            return epsonToPrinterStatus(result)
        }
        
        result = builderValue.addTextAlign(Int32(toEpsonAlign(align)))
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addTextAlign", detail:"\(align)")
            return epsonToPrinterStatus(result)
        }
        
        result = builderValue.addTextLineSpace(lineSpace)
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addTextLineSpace", detail:"\(lineSpace)")
            return epsonToPrinterStatus(result)
        }
        
        result = builderValue.addTextLang(Int32(EPSON_TEXT_LANG.rawValue))
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addTextLang", detail:"\(EPSON_TEXT_LANG)")
            return epsonToPrinterStatus(result)
        }
        
        let textWidth = 1, textHeight = 1
        result = builderValue.addTextSize(textWidth, height:textHeight)
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addTextSize", detail:"width:\(textWidth) height:\(textHeight)")
            return epsonToPrinterStatus(result)
        }
        
        let styleBold = isBold ? EPOS_OC_TRUE : EPOS_OC_FALSE;
        let styleUnderline = isUnderLine ? EPOS_OC_TRUE : EPOS_OC_FALSE;
        result = builderValue.addTextStyle(EPOS_OC_FALSE, ul:styleUnderline, em:styleBold, color:Int32(EPOS_OC_COLOR_1.rawValue))
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addTextStyle", detail:"reverse:\(EPOS_OC_FALSE) ul:\(styleUnderline) em:\(styleBold) color:\(EPOS_OC_COLOR_1)")
            return epsonToPrinterStatus(result)
        }
        
        result = builderValue.addTextPosition(0)
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addTextPosition", detail:"0")
            return epsonToPrinterStatus(result)
        }
        
        if newLine {
            let last = (text as NSString).characterAtIndex((text as NSString).length-1)
            if !NSCharacterSet.newlineCharacterSet().characterIsMember(last) {
                text = text + "\n"
            }
        }
        
        result = builderValue.addText(text)
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addText", detail:text)
            return epsonToPrinterStatus(result)
        }
        
        result = builderValue.addFeedUnit(feed)
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addFeedUnit", detail:"\(feed)")
            return epsonToPrinterStatus(result)
        }
        
        return .SUCCESS
    }
    
    func printTextForTextMode(text: String) -> PRINTER_STATUS {
        return printTextForTextMode(text, align:.LEFT, lineSpace:EPSON_LINE_SPACE, feed:0, underLine:false, bold:false, newLine:true)
    }

//MARK: Image Operation

    func printImage(image: UIImage, halfTone: EposOcHalftone, brightness: CGFloat) -> PRINTER_STATUS {
        guard let builderValue = builder else { return .ERR_FAILURE }
        let result = builderValue.addImage(image, x:0, y:0, width:min(lineWidth, Int(image.size.width)), height:Int(image.size.height), color:Int32(EPOS_OC_COLOR_1.rawValue), mode:Int32(EPOS_OC_MODE_MONO.rawValue), halftone:Int32(halfTone.rawValue), brightness:Double(brightness))
        if result != Int32(EPOS_OC_SUCCESS.rawValue) {
            ShowMsg.showExceptionEpos(result, method:"addImage", detail:"vendor:\(vendor) address:\(address) model:\(model)")
            return epsonToPrinterStatus(result)
        }
        
        return .SUCCESS
    }
    
    func printImage(image: UIImage, atuoAdjust: Bool) -> PRINTER_STATUS {
        let imageToPrint = atuoAdjust ? prepareImageForPrint(image) : image
        return printImage(imageToPrint, halfTone:EPOS_OC_HALFTONE_THRESHOLD, brightness:1.0)
    }
}
