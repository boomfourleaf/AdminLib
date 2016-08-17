//
//  flApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum flApiState: Int {
    case None,
    DownloadPlist,
    DownloadImages,
    ResizeImages,
    BeforeFinishRun,
    Done
}

public enum flApiToDoAction: Int {
    case None,
    ActivateLicense
}

public protocol flApiDelegate: class {
    func updateProgress(percent: Int)
}

public class flApi {
    public var api = ""
    public var parameters = [String]()
    public var numberOfDownloadedImages = 0
    public var numberOfResizeImages = 0
    public var numberOfBeforeFinishRun = 0
    public var finishedDownloadedImages = 0 { didSet { delegate?.updateProgress(progress()) } }
    public var finishedResizeImages = 0 { didSet { delegate?.updateProgress(progress()) } }
    public var finishedBeforeFinishRun = 0 { didSet { delegate?.updateProgress(progress()) } }
    public var state = flApiState.None { didSet { delegate?.updateProgress(progress()) } }
    public weak var delegate: flApiDelegate?
//}

//MARK: Public Methods
//extension flApi {
    
    public class func parseData(data: NSData, type: flCloudDataType) -> ObjcDictionary? {
        switch type {
            case .plist: return data.plist?.dictionaryObject
            case .json: return data.json?.dictionaryObject
            case .text:
                if let text = String(data: data, encoding: NSUTF8StringEncoding) {
                    return ["text": text]
                }
            default: break
        }

        // Parsing Error
        let text = String(data: data, encoding: NSUTF8StringEncoding)
        flLog.error("error can not parse data (\(type)) \(text ?? data)")
        return nil
    }
//}

//MARK: Public Methods
//extension flApi {
    public func rootUrl() -> String {
        return flServerConfigure.shareObject.rootUrl
    }
    
    public func url() -> String {
        // server : https://dev.afourleaf.com:8080
        // api : service/info/{0}/
        // parameters : [1]
        var replaceStrings: [(from: String, to:String)] = []
        for (i, value) in parameters.enumerate() {
            replaceStrings.append((from: "{\(i)}", to: value))
        }
        
        // Random number to prevent caching in uncontrol network enviroment
        replaceStrings.append((from: "[random]", to: randomNumber()))
        replaceStrings.append((from: "[fuid]", to: flServiceController.FUID))
        
        return replaceStrings.reduce(rootUrl() + "/" + api) { $0.stringByReplacingOccurrencesOfString($1.from, withString: $1.to) }
    }
    
    public func filePath() -> String {
        return ""
    }
    
    public func imageAndDataPaths() -> [String] {
        return []
    }
    
    public func imageResizeTo() -> [[String]] {
        return []
    }
    
    public func fetch(showNetworkIndicator: Bool, type: flCloudDataType, validate: Bool=false) -> ObjcDictionary? {
        var dict: ObjcDictionary?
        
        if showNetworkIndicator {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        
        // download data
        if let data = downloadPlist() {
            dict = flApi.parseData(data, type:type)
        }
        
        if showNetworkIndicator {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        // Validate Status
        if validate {
            if let dictValue = dict,
                status = JSON(dictValue)["status"].int where status  == 200 {
                return dict

            } else {
                return nil
            }
        
        // Not Validate
        } else {
           return dict
        }
    }
    
    public func fetch(showNetworkIndicator: Bool) -> ObjcDictionary? {
        return fetch(showNetworkIndicator, type:.plist, validate: true)
    }
    
    // main run
    public func run(showNetworkIndicator: Bool) -> flApiToDoAction {
        var action = flApiToDoAction.None
        if showNetworkIndicator {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        
        synced(self) {
            action = self._run()
        }
        
        if showNetworkIndicator {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        return action
    }
    
    public func run() -> flApiToDoAction {
        return run(true)
    }
    
    public func beforeFinishRunCount(plist: ObjcDictionary) -> Int {
        return 0
    }
    
    // Do something after download all datas
    public func beforeFinishRun(plist: ObjcDictionary) -> Bool {
        return true
    }
    
    public func blendImage(data: ObjcDictionary, name: String, withBlendImage blend: String, outSuffixName suffix: String) -> Bool {
        let imageData = flApi.getPicData(JSON(data), name:name)
        return blendImageData(imageData, withBlendImage:blend, outSuffixName:suffix)
    }
    
    // 5% for plist, 80% for download images, 10% for resize & blend
    public func progress() -> Int {
        switch state {
        case .None: return 0
        case .DownloadPlist: return 5
        case .DownloadImages, .ResizeImages, .BeforeFinishRun:
            let totalDownloadImage = CGFloat(numberOfDownloadedImages) * 1.0
            let progressDownloadImage = CGFloat(finishedDownloadedImages) * 1.0
            
            let totalResizeAndBeforeFinishRun = CGFloat(numberOfResizeImages + numberOfBeforeFinishRun) * 1.0
            let progressResizeAndBeforeFinishRun = CGFloat(finishedResizeImages + finishedBeforeFinishRun) * 1.0
            
            if 0 != totalDownloadImage && 0 == totalResizeAndBeforeFinishRun {
                let percent = 10 + Int(progressDownloadImage / totalDownloadImage * 90.0)
                return percent
                
            } else if 0 != totalDownloadImage && 0 != totalResizeAndBeforeFinishRun {
                let percent = 10 + Int(progressDownloadImage / totalDownloadImage * 60.0) + Int(progressResizeAndBeforeFinishRun / totalResizeAndBeforeFinishRun * 30.0)
                return percent
                
            } else {
                return 100
            }
        case .Done: return 100
        }
    }
}

//MARK: Private Methods
extension flApi {
    private func randomNumber() -> String {
        let min: UInt32 = 0 //Get the current text from your minimum and maximum textfields.
        let max: UInt32 = 9999999
        
        let randNum = arc4random() % (max - min) + min //create the random number.
        
        let num = String(format: "%.10d", randNum) //Make the number into a string.
        return num
    }
    
    private func downloadPlist() -> NSData? {
        // Downlaod pcakge
        let rawUrl = url()
        if let urlString = rawUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
            let urlToDownload = NSURL(string: urlString) {
            
            if Bool(Int(LOG_NETWORK_DOWNLOAD_UPLOAD)) {
                flLog.info("dl \(rawUrl)")
            }
            let urlData = NSData(contentsOfURL: urlToDownload)
            if Bool(Int(LOG_NETWORK_DOWNLOAD_UPLOAD)) {
                flLog.info("finished \(rawUrl)")
            }
            
            return urlData
        }
        return nil
    }
    
    private func resizeImagesCount(plist: ObjcDictionary) -> Int {
        var count = 0
        let imageResizeToVaue = imageResizeTo()
        for (i, imageAndDataPath) in imageAndDataPaths().enumerate() {
            if i < imageResizeToVaue.count {
                let urls = getImageUrls(plist, withPath:imageAndDataPath)
                count += urls.count * imageResizeToVaue[i].count
            }
        }
        
        return count
    }
    
    // resize images to given size configured at -imageResizeTo
    private func resizeImages(plist: ObjcDictionary?) -> Bool {
        finishedResizeImages = 0
        let imageResizeToValue = imageResizeTo()
        if let plistValue = plist {
            for (i, imageAndDataPath) in imageAndDataPaths().enumerate() {
                if i < imageResizeToValue.count {
                    let urls = getImageUrls(plistValue, withPath:imageAndDataPath)

                    for pictureData in urls {
                        let imagePath = flImageCache.imagePathFor(pictureData.url,
                            forHash:pictureData.hash)
                        
                        for strSize in imageResizeToValue[i] {
                            let sizePart = strSize.componentsSeparatedByString("x")
                            if let width = sizePart[0].toCGFloat(),
                                let height = sizePart[1].toCGFloat() {
                                let size = CGSizeMake(width, height)
                                
                                autoreleasepool {
                                    flResizeImage.createImage(imagePath, atSize:size)
                                }
                                finishedResizeImages += 1
                            } else {
                                flLog.error("resize image parser failed for \(strSize)")
                                return false
                            }
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    // Catching all image urls from plist
    private func getImageUrlsFromPlist(plist: ObjcDictionary) -> [PictureData] {
        return getImageUrls(plist, withPaths:imageAndDataPaths())
    }
    
    // Save plist data to file path
    private func savePlistToFile(data: NSData?) {
        if let dataValue = data {
            let filePathValue = filePath()

            flFile.deleteIfExist(filePathValue)
            
            dataValue.writeToFile(filePathValue, atomically:true)
        }
    }
    
    private func _run() -> flApiToDoAction {
        state = .None

        // download data
        state = .DownloadPlist
        //TODO: Check return with finally
        if let data = downloadPlist() {
            if let plist = flApi.parseData(data, type:.plist) {
                if let status = plist[API_ROOT_STATUS] as? Int {
                    switch status {
                    case 200: // OK
                        break
                    case 201: // Not modified (201)
                        state = .Done
                        return .None
                    case 10001: // NO UDID Found, Do Active License
                        state = .Done
                        return .ActivateLicense
                    default: // Error
                        flLog.error("error \(plist[API_ROOT_STATUS_MSG]) (\(status))")
                        state = .Done
                        return .None
                    }
                }
                
                // find image urls
                let imageUrls = getImageUrlsFromPlist(plist)
                numberOfDownloadedImages = imageUrls.count
                numberOfResizeImages = resizeImagesCount(plist)
                numberOfBeforeFinishRun = beforeFinishRunCount(plist)
                
                // Download all images to cache
                state = .DownloadImages
                if !downloadImages(imageUrls) {
                    return .None
                }
                
                state = .ResizeImages
                if !resizeImages(plist) {
                    return .None
                }
                
                state = .BeforeFinishRun
                if !beforeFinishRun(plist) {
                    return .None
                }
                
                savePlistToFile(data)
                state = .Done
                
            } else {
                state = .Done
                return .None
            }
            
        } else {
            return .None
        }
        
        return .None
    }
}

//MARK: Image Processing
extension flApi {
    private func blendImageData(imageData: PictureData, withBlendImage blend: String, outSuffixName suffix: String) -> Bool {
        let originPath = flImageCache.imagePathFor(imageData.url, forHash:imageData.hash)
        // Path
        let fileName = ((originPath as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
        let path = (originPath as NSString).stringByDeletingLastPathComponent
        
        let newFileName = fileName + "\(suffix).\((originPath as NSString).pathExtension)"
        let newPath = (path as NSString).stringByAppendingPathComponent(newFileName)
        
        if flFile.isExist(newPath) {
            return true
        }
        
        // Blend Images
        let bottomImageUrl = NSURL(fileURLWithPath:originPath)
        if let bottomImageData = NSData(contentsOfURL: bottomImageUrl),
            let bottomImage = UIImage(data: bottomImageData),
            let image = UIImage(named:blend) {
            
            let newSize = CGSizeMake(image.size.width, image.size.height)
                
            UIGraphicsBeginImageContext( newSize );
            
            // Use existing opacity as is
            bottomImage.drawInRect(CGRectMake(0,0,newSize.width,newSize.height))
            // Apply supplied opacity
            image.drawInRect(CGRectMake(0,0,newSize.width,newSize.height), blendMode:CGBlendMode.DestinationIn, alpha:1.0)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            flLog.info("newPath \(newPath)")
            
            if let newImageValue = newImage,
                let data = UIImagePNGRepresentation(newImageValue) {
                data.writeToFile(newPath, atomically:true)
            }
        }
        
        return true
    }
}

//MARK: Get Data Urls
extension flApi {
    private func getImageUrls(plist: AnyObject, withPath path: String) -> [PictureData] {
        if let firstChar = path[0] {
            switch firstChar {
            case "[": // parsing key tag "[]"
                if let plistDict = plist as? ObjcDictionary {
                    do {
                        // Check if exist [key]...
                        let regex = try NSRegularExpression(pattern:"\\[(\\w+)](.*)", options:.CaseInsensitive)
                        let matches = regex.matchesInString(path, options:NSMatchingOptions(rawValue: 0), range:NSMakeRange(0, (path as NSString).length))
                        // get key string
                        if matches.count >= 1 && matches[0].numberOfRanges >= 1 {
                            let keyRange = matches[0].rangeAtIndex(1)
                            let restRange = matches[0].rangeAtIndex(2)
                            
                            let keyText = (path as NSString).substringWithRange(keyRange)
                            let restText = (path as NSString).substringWithRange(restRange)
                            
                            if let plistDeeper: AnyObject = plistDict[keyText] {
                                return getImageUrls(plistDeeper, withPath:restText)
                            }
                        }
                    } catch _ {
                        
                    }
                    
                }
            case "/": // parsing array tag "/"
                if let plistArr = plist as? [AnyObject] {
                    let newPath = (path as NSString).substringWithRange(NSMakeRange(1, (path as NSString).length - 1))
                    
                    return plistArr.reduce([PictureData]()) { $0 + getImageUrls($1, withPath:newPath) }
                }
            case "<": // parsing value tag "<>"
                if let plistDict = plist as? ObjcDictionary {
                    do {
                        // Check if exist [key]...
                        let regex = try NSRegularExpression(pattern:"\\<(\\w+)>", options:.CaseInsensitive)
                        let matches = regex.matchesInString(path, options:NSMatchingOptions(rawValue: 0), range:NSMakeRange(0, (path as NSString).length))
                        // get key string
                        if matches.count >= 1 && matches[0].numberOfRanges >= 1 {
                            let valueRange = matches[0].rangeAtIndex(1)
                            
                            let keyText = (path as NSString).substringWithRange(valueRange)
                            let urlData = flApi.getPicData(JSON(plistDict), name:keyText)
                            if urlData.url != "" {

                                return [urlData]
                            }
                        }
                    } catch _ {
                        
                    }
                }
            default: break
            }
        }
        return []
    }
    
    private func getImageUrls(plist: AnyObject, withPaths paths: [String]) -> [PictureData] {
        return paths.reduce([PictureData]()) { $0 + getImageUrls(plist, withPath:$1) }
    }
}
