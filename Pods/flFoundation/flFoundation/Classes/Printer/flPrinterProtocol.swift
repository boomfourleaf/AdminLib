//
//  flPrinterProtocol.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/5/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON


var EPSON_INTERVAL: Int { return 1000 }
var EPSON_FONT: EposOcFont { return EPOS_OC_FONT_B }
var EPSON_LANG: EposOcModel { return EPOS_OC_MODEL_SOUTHASIA }
var EPSON_TEXT_LANG: EposOcLang { return EPOS_OC_LANG_TH }
var EPSON_LINE_SPACE: Int { return 24 }
var EPSON_SEND_TIMEOUT: Int { return 20 * 1000 }
var PRINT_TEXT_LINE_BREAK: NSLineBreakMode { return .ByWordWrapping }


public enum PRINTER_ALIGN: Int {
    case LEFT = 0, CENTER, RIGHT
}

public enum PRINTER_CUT: Int {
    case NO_FEED = 0, FEED, RESERVE
}

public enum PRINTER_PRINT_MODE: Int {
    case LINE = 0, RASTER
}

/// flPrinterProtocol is used for rendering commands and printing.
/// Thread safe, but must be run on serial queue.
public protocol flPrinterProtocol: class {
    var lineMaxChar: Int { get set }
    var lineWidth: Int { get set }
    var printMode: PRINTER_PRINT_MODE { get set }
    var vendor: String { get set }
    var address: String { get set }
    var model: String { get set }
    
    func openPrinter() -> PRINTER_STATUS
    func closePrinter(showError: Bool) -> PRINTER_STATUS
    func sendData() -> PRINTER_STATUS
    func openCashDrawer() -> PRINTER_STATUS
    func feed(feed: Int) -> PRINTER_STATUS
    func cutPaper(cutType: PRINTER_CUT) -> PRINTER_STATUS
    func newBuilder()
    
    // Image
    func printImage(image: UIImage, atuoAdjust: Bool) -> PRINTER_STATUS
    
    // Text
    func adjustFontSize(size: CGFloat) -> CGFloat
    
    // Optional
    func printImage(image: UIImage) -> PRINTER_STATUS

    func closePrinter() -> PRINTER_STATUS
    func defaultFontWhenParseOptionError() -> UIFont
    func prepareImageForPrint(image: UIImage) -> UIImage
    
    // Optional Text Mode ( For Tranditional Printer only )
    func printTextForTextMode(textInput: String, align: PRINTER_ALIGN, lineSpace: Int, feed: Int, underLine isUnderLine: Bool, bold isBold: Bool, newLine: Bool) -> PRINTER_STATUS
}

//MARK: - Default Values
extension flPrinterProtocol {
    public  func closePrinter() -> PRINTER_STATUS {
        return closePrinter(true)
    }
    
    public func printImage(image: UIImage) -> PRINTER_STATUS {
        return printImage(image, atuoAdjust: true)
    }
}

//MARK: - APIs
extension flPrinterProtocol {
    public func printOnDeviceLogo() -> PRINTER_STATUS {
        if let invoiceConfigure = flGlobal.invoiceConfigure() {
            let logoPath = flImageCache.imagePathForData(flApi.getPicData(JSON(invoiceConfigure), name:API_INVOICE_LOGO))
            
            if let image = UIImage(contentsOfFile:logoPath) {
                let result = printImage( image )
                
                if result != .SUCCESS {
                    ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"OnDeviceLogo", detail:"vendor:\(vendor) address:\(address) model:\(model)")
                    return result
                }
            }
        }
        return .SUCCESS
    }
    
    public func printText(command: String, text: String, isBold: Bool, isUnderLine: Bool, isRedColor: Bool, headFont: UIFont?, normalFont: UIFont) -> PRINTER_STATUS {
        var rawText = text
        
        let align : PRINTER_ALIGN
        switch command {
        case "CenterText": align = .CENTER
        case "LeftText": align = .LEFT
        case "RightText": align = .RIGHT
        default: align = .LEFT
        }
        
        // Use Image Mode for Head sylte or Raster Mode
        if nil != headFont || .RASTER == printMode {
            if rawText == "" {
                rawText = " "
            }
            let font = headFont ?? normalFont
            
            // Text to Raster Image
            let image = textToImage(rawText, font:font, align:align, underLine:isUnderLine, invertColor:isRedColor)
            let result = printImage( image )
            if result != .SUCCESS {
                ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printImage", detail:"vendor:\(vendor) address:\(address) model:\(model)")
                return result
            }
            
        // Text Mode
        } else {
            // Split by new line
            if let texts = flCharacter.stringSplitByNewLine(rawText) {
                for text in texts {
                    // Split by max char width
                    if let lines = flCharacter.stringSplit(text, byLength: lineMaxChar) {
                        for line in lines {
                            let result = printCommandTextForTextMode(line, align:align, lineSpace:EPSON_LINE_SPACE, feed:0, underLine:isUnderLine, bold:isBold, newLine:true)
                            if result != .SUCCESS {
                                ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printCommandTextForTextMode", detail:line)
                                return result
                            }
                        }
                    }
                }
            }
        }
        return .SUCCESS
    }
    
    public func printDoubleText(leftTextInput: String, rightText rightTextInput: String, isBold: Bool, isUnderLine: Bool, isRedColor: Bool, headFont: UIFont?, normalFont: UIFont) -> PRINTER_STATUS {
        var leftText = leftTextInput
        var rightText = rightTextInput
        
        // Use Image Mode for Head sylte or Raster Mode
        if nil != headFont || .RASTER == printMode {
            if leftText == "" {
                leftText = " "
            }
            if rightText == "" {
                rightText = " "
            }
            
            let font = headFont ?? normalFont
            
            // Text to Raster Image
            let image = doubleTextToImage(leftText, rightText:rightText, font:font, underLine:isUnderLine, invertColor:isRedColor)
            let result = printImage( image )
            if result != .SUCCESS {
                ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printImage", detail:"vendor:\(vendor) address:\(address) model:\(model)")
                return result
            }
            
        // Text Mode
        } else {
            if let texts = flCharacter.stringSplit(leftText, byLength:lineMaxChar - 1 - (rightText as NSString).length) { // Left[1 space]Right
                
                var isFirstLine = true
                for text in texts {
                    var finalText = ""
                    if isFirstLine {
                        var length = flCharacter.stringLength(text) + flCharacter.stringLength(rightText)
                        if length > lineMaxChar {
                            length = lineMaxChar
                        }
                        
                        let spaceLenght = lineMaxChar - length
                        let space = spaceLenght > 0 ? String(count: spaceLenght, repeatedValue: Character(" ")) : ""
                        
                        finalText = text + space + rightText
                    } else {
                        finalText = text
                    }
                    let result = printCommandTextForTextMode(finalText, align:.LEFT, lineSpace:EPSON_LINE_SPACE, feed:0, underLine:isUnderLine, bold:isBold, newLine:true)
                    if result != .SUCCESS {
                        ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printCommandTextForTextMode", detail:finalText)
                        return result
                    }
                    isFirstLine = false
                }
                return .SUCCESS
            }
        }
        return .SUCCESS
    }
    
    public func printCommand(cmd: [NSObject: AnyObject]) -> PRINTER_STATUS {
        let cmdJson = JSON(cmd)
        
        guard let command = cmdJson["command"].string else { return .ERR_FAILURE }
        let value = cmdJson["value"]
        
        // Option parser
        var isBold = false
        var isUnderLine = false
        var isRedColor = false
        var headFont: UIFont?
        let normalFont = headFontByOption("HN7") ?? defaultFontWhenParseOptionError()
        for option in cmdJson["value"]["option"].arrayValue.lazy.map({ $0.stringValue }) {
            switch option {
            case "B1", "B2": isBold = true
            case "U": isUnderLine = true
            case "CRED": isRedColor = true
            default:
                if let tmpFont = headFontByOption(option) {
                    headFont = tmpFont
                }
            }
        }
        
        switch command {
        // On Device Logo
        case "OnDeviceLogo":
            return printOnDeviceLogo()
            
        // Print Text
        case "CenterText", "LeftText", "RightText":
            let text = value["text"][0].stringValue
            return printText(command, text: text, isBold: isBold, isUnderLine: isUnderLine, isRedColor: isRedColor, headFont: headFont, normalFont: normalFont)
            
        case "DoubleText":
            let leftText = value["text"][0].stringValue
            let rightText = value["text"][1].stringValue
            return printDoubleText(leftText, rightText: rightText, isBold: isBold, isUnderLine: isUnderLine, isRedColor: isRedColor, headFont: headFont, normalFont: normalFont)
            
            
        case "Feed": return feed(cmdJson["value"]["text"][0].intValue)
        case "FeedToCutAndCut": return cutPaper(.FEED)
        case "OpenDrawer": return openCashDrawer()
        default: break
        }
        
        return .SUCCESS
    }
}

//MARK: Helper
extension flPrinterProtocol {
    public func toNSTextAlign(align: PRINTER_ALIGN) -> NSTextAlignment {
        switch align {
        case .CENTER: return .Center
        case .RIGHT: return .Right
        default: return .Left
        }
    }
    
    public func toEpsonAlign(align: PRINTER_ALIGN) -> Int {
        return align.rawValue
    }
    
    public func epsonToPrinterStatus(printError: Int32) -> PRINTER_STATUS {
        return PRINTER_STATUS(rawValue: Int(printError)) ?? .ERR_FAILURE
    }
    
    public func toEpsonCutType(cutType: PRINTER_CUT) -> Int32 {
        return Int32(cutType.rawValue)
    }
}

//MARK: Text Helper
extension flPrinterProtocol {
    public static func height(text: String, font: UIFont, width: CGFloat, lineBreak lineBreakMode: NSLineBreakMode) -> CGFloat {
        return text == "" ? 0.0 : text.heightForFontCeil(font, width:width)
    }
    
    public static func sizeFor(text: String, font: UIFont, width: CGFloat, lineBreak lineBreakMode: NSLineBreakMode)  -> CGSize {
        return text == "" ? CGSizeZero : text.sizeForFontCeil(font, frameSize:CGSizeMake(width, CGFloat.max))
    }
    
    public func defaultFontWhenParseOptionError() -> UIFont {
        return UIFont.systemFontOfSize(18.0)
    }
    
    func adjustFontSize(size: CGFloat) -> CGFloat {
        if model == EPSON_TM_T88V {
            return size + 20
            
            // U220 Support at least 15
        } else if model == EPSON_TM_U220 && size < 15 {
            return 15
        }
        return size
    }
    
    public func headFontByOption(optionInput: String) -> UIFont? {
        var option = optionInput
        var fontSize: CGFloat = -1
        
        // HNxx for Regular
        // Hxx For Bold
        var fontName = "Helvetica-Bold"
        if option.hasPrefix("HN") {
            fontName = "Helvetica"
            option = "H" + (option as NSString).subString(2, end:(option as NSString).length - 2)
        }
        
        switch option {
        case "H1": fontSize = 40
        case "H2": fontSize = 35
        case "H3": fontSize = 30
        case "H4": fontSize = 25
        case "H5": fontSize = 22
        case "H6": fontSize = 20
        case "H7": fontSize = 18
        case "H8": fontSize = 16
        case "H9": fontSize = 15
        case "H10": fontSize = 14
        case "H11": fontSize = 13
        case "H12": fontSize = 12
        case "H13": fontSize = 11
        case "H14": fontSize = 10
        case "H15": fontSize = 9
        case "H16": fontSize = 8
        default: break
        }
        
        if -1 == fontSize {
            return nil
        }
        
        fontSize = adjustFontSize(fontSize)
        return UIFont(name:fontName, size:fontSize)
    }
}

//MARK: - Raster Mode
extension flPrinterProtocol {
    public func prepareImageForPrint(image: UIImage) -> UIImage {
        // If width > lineWidth, then Resize image to fit width, respect ratio
        if image.size.width > CGFloat(lineWidth) {
            var newImage: UIImage!
            autoreleasepool {
                let imageRatio = image.size.width / image.size.height
                newImage = Self.scaleImage(image, cropToSize: CGSizeMake(CGFloat(lineWidth), CGFloat(lineWidth) / imageRatio))
            }
            
            return newImage
            
        // No Adjust Image
        } else {
            return image
        }
    }
    
    public func addUnderLineToCurrentContext(size: CGSize, invertColor: Bool) {
        let underLineHeight: CGFloat = 2
        let lineColor: UIColor = invertColor ? .whiteColor() : .blackColor()
        if ( size.height >= underLineHeight) {
            let underLineFrame = CGRectMake(0, size.height - underLineHeight, CGFloat(lineWidth), underLineHeight)
            
            let context = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(context, lineColor.CGColor)
            CGContextFillRect(context, underLineFrame)
        }
    }
    
    public func textToImage(text: String, font: UIFont, align: PRINTER_ALIGN, underLine isUnderLine: Bool, invertColor: Bool) -> UIImage {
        let height = Self.height(text, font: font, width: CGFloat(lineWidth), lineBreak: Self.PRINT_TEXT_LINE_BREAK)
        let frameSize = CGSizeMake(CGFloat(lineWidth), height)
        if UIScreen.mainScreen().scale == 2.0 {
            UIGraphicsBeginImageContextWithOptions(frameSize, false, 1.0)
        } else {
            UIGraphicsBeginImageContext(frameSize)
        }
        
        // Backgroudn Color
        let ctr = UIGraphicsGetCurrentContext()
        let color: UIColor = invertColor ? .blackColor() : .whiteColor()
        color.set()
        
        let rect = CGRectMake(0, 0, frameSize.width + 1, frameSize.height + 1)
        CGContextFillRect(ctr, rect)
        
        // Draw Text
        UIColor.blackColor().set()
        
        // Define paragraph styling
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = toNSTextAlign(align)
        paragraphStyle.lineBreakMode = Self.PRINT_TEXT_LINE_BREAK
        
        (text as NSString).drawInRect(rect,
                                      withAttributes: [NSFontAttributeName: font,
                                        NSParagraphStyleAttributeName: paragraphStyle,
                                        NSForegroundColorAttributeName: invertColor ? UIColor.whiteColor() : UIColor.blackColor()])
        
        if isUnderLine {
            addUnderLineToCurrentContext(frameSize, invertColor: invertColor)
        }
        
        let imageToPrint = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return imageToPrint
    }
    
    public func doubleTextToImage(leftText: String, rightText: String, font: UIFont, underLine isUnderLine: Bool, invertColor: Bool) -> UIImage {
        let rightSize = Self.sizeFor(rightText, font:font, width:CGFloat(lineWidth), lineBreak:Self.PRINT_TEXT_LINE_BREAK)
        let leftWidth = CGFloat(lineWidth) - rightSize.width - 10
        let leftHeight = Self.height(leftText, font:font, width:leftWidth, lineBreak:Self.PRINT_TEXT_LINE_BREAK)
        let leftSize = CGSizeMake(leftWidth, leftHeight)
        
        let frameSize = CGSizeMake(CGFloat(lineWidth), max(rightSize.height, leftHeight))
        if UIScreen.mainScreen().scale == 2.0 {
            UIGraphicsBeginImageContextWithOptions(frameSize, false, 1.0)
        } else {
            UIGraphicsBeginImageContext(frameSize)
        }
        
        // Backgroudn Color
        let ctr = UIGraphicsGetCurrentContext()
        let color: UIColor = invertColor ? .blackColor() : .whiteColor()
        color.set()
        
        let rect = CGRectMake(0, 0, frameSize.width + 1, frameSize.height + 1)
        CGContextFillRect(ctr, rect)
        
        // Draw Text
        UIColor.blackColor().set()
        
        // Draw Left Text
        let leftParagraphStyle = NSMutableParagraphStyle()
        leftParagraphStyle.alignment = toNSTextAlign(.LEFT)
        leftParagraphStyle.lineBreakMode = Self.PRINT_TEXT_LINE_BREAK
        
        (leftText as NSString).drawInRect(CGRectMake(0, 0, leftSize.width, leftSize.height),
                                          withAttributes: [NSFontAttributeName: font,
                                            NSParagraphStyleAttributeName: leftParagraphStyle,
                                            NSForegroundColorAttributeName: invertColor ? UIColor.whiteColor() : UIColor.blackColor()])
        
        // Draw Right Text
        let rightParagraphStyle = NSMutableParagraphStyle()
        rightParagraphStyle.alignment = toNSTextAlign(.RIGHT)
        rightParagraphStyle.lineBreakMode = Self.PRINT_TEXT_LINE_BREAK
        
        (rightText as NSString).drawInRect(CGRectMake(CGFloat(lineWidth) - rightSize.width, 0, rightSize.width, rightSize.height),
                                           withAttributes: [NSFontAttributeName: font,
                                            NSParagraphStyleAttributeName: rightParagraphStyle,
                                            NSForegroundColorAttributeName: invertColor ? UIColor.whiteColor() : UIColor.blackColor()])
        
        if isUnderLine {
            addUnderLineToCurrentContext(frameSize, invertColor: invertColor)
        }
        
        let imageToPrint = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return imageToPrint
    }
}

// Tempolary from flResizeImage from master_stable
extension flPrinterProtocol {
    public static func scaleImage(image: UIImage, cropToSize toSize: CGSize) -> UIImage {
        let originWidth: CGFloat
        let originHeight: CGFloat
        if let imgRef = image.CGImage {
            originWidth = CGFloat(CGImageGetWidth(imgRef))
            originHeight = CGFloat(CGImageGetHeight(imgRef))
        } else {
            originWidth = image.size.width
            originHeight = image.size.height
        }
        let originSize = CGSizeMake(originWidth, originHeight)
        
        let originRatio = originSize.width / originSize.height
        let toRatio = toSize.width / toSize.height
        
        UIGraphicsBeginImageContext(toSize)
        
        // crop top, down
        if toRatio > originRatio {
            var drawRect = CGRectZero
            drawRect.size.width = toSize.width
            drawRect.size.height = toSize.width / originRatio
            drawRect.origin.y = 0 - (drawRect.size.height - toSize.height) / 2
            image.drawInRect(drawRect)
            
            // crop left, right
        } else {
            var drawRect = CGRectZero
            drawRect.size.width = toSize.height * originRatio
            drawRect.size.height = toSize.height
            drawRect.origin.x = 0 - (drawRect.size.width - toSize.width) / 2
            image.drawInRect(drawRect)
        }
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy.fixOrientation()
    }
}

//MARK: - Text Mode
extension flPrinterProtocol {
    public func printCommandTextForTextMode(text: String, align: PRINTER_ALIGN, lineSpace: Int, feed: Int, underLine isUnderLine: Bool, bold isBold: Bool, newLine: Bool) -> PRINTER_STATUS {
        // For trandistional printer that doesn't support Thai Vowel, split line manually (up to 4 lines)
        switch model {
        case EPSON_TM_U220:
            if let textParsed = flCharacter.stringVowelParse(text) {
                let textParsedJson = JSON(textParsed)
                if "" == textParsedJson["vowel_up2"].stringValue &&
                    "" == textParsedJson["vowel_up1"].stringValue &&
                    "" == textParsedJson["vowel_down1"].stringValue {
                    let result = printTextForTextMode(textParsedJson["base"].stringValue, align:align, lineSpace:lineSpace, feed:feed, underLine:isUnderLine, bold:isBold, newLine:newLine)
                    if result != .SUCCESS {
                        ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printText", detail:text)
                        return result
                    }
                    
                } else {
                    // Vowel Up 2
                    var result = printTextForTextMode(textParsedJson["vowel_up2"].stringValue, align:align, lineSpace:7, feed:feed, underLine:isUnderLine, bold:isBold, newLine:newLine)
                    if result != .SUCCESS {
                        ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printText", detail:text)
                        return result
                    }
                    
                    // Vowel Up 1
                    result = printTextForTextMode(textParsedJson["vowel_up1"].stringValue, align:align, lineSpace:15, feed:feed, underLine:isUnderLine, bold:isBold, newLine:newLine)
                    if result != .SUCCESS {
                        ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printText", detail:text)
                        return result
                    }
                    
                    // Base
                    result = printTextForTextMode(textParsedJson["base"].stringValue, align:align, lineSpace:15, feed:feed, underLine:isUnderLine, bold:isBold, newLine:newLine)
                    if result != .SUCCESS {
                        ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printText", detail:text)
                        return result
                    }
                    
                    // Vowel Down 1
                    result = printTextForTextMode(textParsedJson["vowel_down1"].stringValue, align:align, lineSpace:7, feed:feed, underLine:isUnderLine, bold:isBold, newLine:newLine)
                    if result != .SUCCESS {
                        ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printText", detail:text)
                        return result
                    }
                }
            }
            
        default:
            let result = printTextForTextMode(text, align:align, lineSpace:lineSpace, feed:feed, underLine:isUnderLine, bold:isBold, newLine:newLine)
            if result != .SUCCESS {
                ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printText", detail:text)
                return result
            }
        }
        
        return .SUCCESS
    }
    
    public func printTextForTextMode(text: String, align: PRINTER_ALIGN, lineSpace: Int, feed: Int, underLine isUnderLine: Bool, bold isBold: Bool, newLine: Bool) -> PRINTER_STATUS {
        flLog.error("Not Yet Support")
        return .SUCCESS
    }
}

//MARK: Config
extension flPrinterProtocol {
    static var PRINT_TEXT_LINE_BREAK: NSLineBreakMode { return .ByWordWrapping }
}
