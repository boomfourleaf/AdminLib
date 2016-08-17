//
//  flServiceController.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/27/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation
import AdSupport
import SwiftyJSON

public final class flServiceController: NSObject {
    public static let sharedService = flServiceController()
    public static let FUID: String = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
    
    public lazy var myroomInfoApi = flMyroomInfoApi()
    public lazy var myroomMsgApi = flMyroomMsgApi()
    public lazy var myroomMsgSnedMarkReadApi = flMyroomMsgSendMarkReadApi()
    public lazy var myroomOrderHisApi = flMyroomOrderHisApi()
    public lazy var myroomFeedbackApi = flMyroomFeedbackApi()
    public lazy var myroomFeedbackPostApi = flMyroomFeedbackPostApi()
    public lazy var myroomProfileApi = flMyroomProfileApi()
    public lazy var specialMainApi = flSpecialMainApi()
    public lazy var galleryMainApi = flGalleryMainApi()
    public lazy var firstAidMainApi = flFirstAidApi()
    public lazy var hotelInfoMainApi = flHotelInfoMainApi()
    public lazy var diningMainApi = flDiningMainApi()
    public lazy var diningOrderMainApi = flDiningOrderApi()
    public lazy var diningOrderStatusApi = flDiningOrderStatusApi()
    public lazy var diningOpenTableListApi = flDiningOpenTableListApi()
    public lazy var diningOpenTableOrderListApi = flDiningOpenTableOrderListApi()
    public lazy var diningOpenBillListApi = flDiningOpenBillListApi()
    public lazy var diningOpenBillOrderListApi = flDiningOpenBillOrderListApi()
    public lazy var diningOrderChangeApi = flDiningOrderChangeApi()
    public lazy var diningOrderMoveApi = flDiningOrderMoveApi()
    public lazy var diningInvoiceApi = flDiningInvoiceApi()
    public lazy var diningVoidApi = flDiningVoidApi()
    public lazy var diningOrderChangeGuestAmountApi = flDiningOrderChangeGuestAmountApi()

    public lazy var weatherMainApi = flWeatherMainApi()
    public lazy var mapMainApi = flMapMainApi()
    
    public lazy var activityCategoryApi = flActivityCategoryApi()
    public lazy var activityOrderApi = flActivityOrderApi()
    public lazy var spaCategoryApi = flSpaCategoryApi()
    public lazy var spaOrderApi = flSpaOrderApi()
    public lazy var housekeepingMainApi = flHousekeepingMainApi()
    public lazy var houseKeepingOrderApi = flHousekeepingOrderApi()
    public lazy var housekeepingOrderHisApi = flHousekeepingOrderHisApi()
    public lazy var ctHoneymoonCategoryApi = flCtHoneymoonCategoryApi()
    public lazy var ctHoneymoonOrderApi = flCtHoneymoonOrderApi()
    
    public lazy var languageApi = flLanguageApi()
    public lazy var printerNewJobApi = flPrinterNewJobApi()
    public lazy var logPrintQueueApi = flLogPrintQueueApi()
    
    public lazy var logPrintLogApi = flLogPrintLogApi()
    public lazy var logPrintSuccessApi = flLogPrintSuccessApi()
    public lazy var cashierDiscountPercentApi = flCashierDiscountPercentApi()
    public lazy var cashierChangeOrderStatusApi = flCashierChangeOrderStatusApi()
    public lazy var cashierOrderLogApi = flCashierOrderLogApi()
    public lazy var stockItemListApi = flStockItemListApi()
    public lazy var stockItemTransactionListApi = flStockItemTransactionListApi()
    public lazy var stockItemNewTransactionApi = flStockItemNewTransactionApi()
    public lazy var stockNewItemApi = flStockNewItemApi()
    public lazy var closeShiftPrepareApi = flCloseShiftPrepareApi()
    public lazy var closeShiftApi = flCloseShiftApi()
    public lazy var activationWithLicenseApi = flActivationWithLicenseApi()
    public lazy var cashierOpenCashDrawerApi = flCashierOpenCashDrawerApi()
    
    public lazy var printQueueDeleteApi = flPrintQueueDeleteApi()
}

//MARK: Private API
extension flServiceController {
    private func dictFor(filePath: String) -> ObjcDictionary? {
        return NSDictionary(contentsOfFile: filePath) as? ObjcDictionary
    }
    
    private func arrayFor(filePath: String) -> [AnyObject]? {
        return NSArray(contentsOfFile: filePath) as? [AnyObject]
    }
}


//MARK: Get Information
extension flServiceController {
    public func getDict(api: flApi) -> ObjcDictionary? {
        return dictFor(api.filePath())
    }
    
    public func sendData(api: flApi, withData sendData: NSObject, type: flCloudDataType) throws -> NSData? {
        let url = api.url()
        flLog.info("send request \(url)")
        let connection = flUrlConnection(url: url, sendType: type, sendData: sendData)
        
        do {
            let returnData = try connection.fetchData()
            flLog.info("finished request \(url)")
            return returnData

        } catch let error as NSError {
            flLog.error("error \(url) \(error.description)")
            throw error

        } catch let error as flUrlConnection.FetchDataError {
            flLog.error("error \(url) \(error.reason)")
            throw error
        }
    }

    public func send(api: flApi, withData dataInput: NSObject, type: flCloudDataType = .plist, returnType: flCloudDataType = .plist) -> ObjcDictionary? {

        do {
            if let data = try sendData(api, withData: dataInput, type: type),
                let plist = flApi.parseData(data, type: returnType) {
                if nil == plist["status"] {
                    return ["status" : 9999, "status_msg": "error"]
                }
                return plist
                
            } else {
                return ["status" : 9999, "status_msg": "error"]
            }

        } catch let error as NSError {
            let dict: ObjcDictionary = ["datas": ["error_text": error.localizedDescription],
                                        "status": error.code,
                                        "status_msg": error.domain]
            flLog.error("error2223: \(error.localizedDescription)")
            flLog.error("dict \(dict)")
            return dict

        } catch let error as flUrlConnection.FetchDataError {
            let dict: ObjcDictionary = ["status" : 9999, "status_msg": "error"]
            flLog.error(error.reason)
            flLog.error("dict \(dict)")
            return dict
        }
    }
    
    public func send(api: flApi, withText text: String) -> ObjcDictionary? {
        return send(api, withData: text, type: .text)
    }
    
    public func send(api: flApi, withData dataDict: ObjcDictionary, withImageDatas imageDatas: [AnyObject]) -> ObjcDictionary? {
        return send(api, withData: ["data": dataDict, "images": imageDatas], type: .jsonAndImage, returnType: .json)
    }
    
    public func send(api: flApi, withData dataDict: ObjcDictionary, withImages images: [UIImage]) -> ObjcDictionary? {
        var imageDatas = [NSData]()
        for image in images {
            let smallImage = flResizeImage.scaleImage(image, toResolution: 700)
            if let imageData = UIImageJPEGRepresentation(smallImage, 0.8) {
                imageDatas.append(imageData)
            }
        }
        return send(api, withData: dataDict, withImageDatas: imageDatas)
    }
    
    public func send(api: flApi, data: flDataProtocol, withImages images: [UIImage]?=nil) -> flServiceResponse {
        let response: ObjcDictionary?
        let data = ["data": ["model_data": data.toDict().dictionaryObjectValue] ]
        // Send data with images
        if let imagesValue = images {
            response = send(api, withData: data, withImages: imagesValue)
            
        // Send only data
        } else {
            response = send(api, withData: data, type: .json, returnType: .json)
        }
        
        
        if let responseValue = response {
            let responseJson = JSON(responseValue)
            let responseStatus = responseJson["status"].intValue
            
            // Error
            if responseStatus  != 200 {
                return .error(error: flApiError.fromData(responseValue), data:responseValue, action:nil)
            } else {
                return .success(code: responseStatus, data: responseValue)
            }
        }
        
        let apiError = flApiError.WithMessage(code: flApiError.INTERNET_CONNECTION_ERROR_CODE, title: flApiError.INTERNET_CONNECTION_ERROR_TITLE, description: flApiError.INTERNET_CONNECTION_ERROR_DESCRIPTION)
        return .error(error: apiError, data:nil, action:nil)
    }
}

//MARK: MyRoom
extension flServiceController {
    public func getMyroomInfo(cusId: String) -> ObjcDictionary? {
        return getDict(myroomInfoApi)
    }

    public func getMyroomMsg(cusId: String) -> ObjcDictionary? {
        return getDict(myroomMsgApi)
    }
    
    public func getMyroomOrderHis(cusId: String) -> ObjcDictionary? {
        return getDict(myroomOrderHisApi)
    }
    
    public func getMyroomFeedback(cusId: String) -> ObjcDictionary? {
        return getDict(myroomFeedbackApi)
    }
    
    public func sendMyroomFeedback(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(myroomFeedbackPostApi, withData: dataDict)
    }
    
    public func getMyroomProfile(cusId: String) -> ObjcDictionary? {
        return getDict(myroomProfileApi)
    }
}

//MARK: Activity
extension flServiceController {
    public func getActivityCategory(cusId: String) -> ObjcDictionary? {
        return getDict(activityCategoryApi)
    }
    
    public func sendActivityOrder(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(activityOrderApi, withData: dataDict)
    }
}

//MARK: Special Offer
extension flServiceController {
    public func getSpecialMain(cusId: String) -> ObjcDictionary? {
        return getDict(specialMainApi)
    }
}

//MARK: First Aid
extension flServiceController {
    public func getFirstAidMain(cusId: String) -> ObjcDictionary? {
        return getDict(firstAidMainApi)
    }
}

//MARK: Gallery
extension flServiceController {
    public func getGallery(cusId: String) -> ObjcDictionary? {
        return getDict(galleryMainApi)
    }
}

//MARK: Hotel Info
extension flServiceController {
    public func getHotelInfo(cusId: String) -> ObjcDictionary? {
        return getDict(hotelInfoMainApi)
    }
}

//MARK: Dining
extension flServiceController {
    public func getDining(cusId: String) -> ObjcDictionary? {
        return getDict(diningMainApi)
    }
    
    public func sendDiningOrder(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(diningOrderMainApi, withData: dataDict)
    }
    
    public func checkOrderStatus(data: String) -> ObjcDictionary? {
        return send(diningOrderStatusApi, withText: data)
    }
    
    public func getOpenTableList(cusId: String) -> ObjcDictionary? {
        return getDict(diningOpenTableListApi)
    }

    public func getOpenBillList(cusId: String) -> ObjcDictionary? {
        return getDict(diningOpenBillListApi)
    }

    public func sendOrderChange(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(diningOrderChangeApi, withData: dataDict, type: .json, returnType: .text)
    }

    public func sendOrderMove(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(diningOrderMoveApi, withData: dataDict, type: .json, returnType: .text)
    }

    public func sendInvoice(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(diningInvoiceApi, withData: dataDict, type: .json, returnType: .json)
    }

    public func sendVoid(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(diningVoidApi, withData: dataDict, type: .json, returnType: .json)
    }
    
    public func sendOrderChangeGuestAmount(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(diningOrderChangeGuestAmountApi, withData: dataDict, type: .json, returnType: .json)
    }

    public func sendCashierDiscountPercent(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(cashierDiscountPercentApi, withData: dataDict, type: .json, returnType: .json)
    }
    
    public func sendCashierChangeOrderStatusApi(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(cashierChangeOrderStatusApi, withData: dataDict, type: .json, returnType: .json)
    }
    
    public func sendCashierOrderLogApi(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(cashierOrderLogApi, withData: dataDict, type: .json, returnType: .json)
    }
    
    public func sendCashierOpenCashDrawer(cashDrawerNumber: Int) -> ObjcDictionary? {
        cashierOpenCashDrawerApi.parameters = ["\(cashDrawerNumber)"]
        return cashierOpenCashDrawerApi.fetch(true, type: .json, validate: true)
    }
    
    
    public func sendPrintQueueDelete(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(printQueueDeleteApi, withData: dataDict, type: .json, returnType: .json)
    }
}

//MARK: Weather
extension flServiceController {
    public func getWeather(cusId: String) -> ObjcDictionary? {
        return getDict(weatherMainApi)
    }
}

//MARK: Map
extension flServiceController {
    public func getMap(cusId: String) -> ObjcDictionary? {
        return getDict(mapMainApi)
    }
}

//MARK: Spa
extension flServiceController {
    public func getSpaCategory(cusId: String) -> ObjcDictionary? {
        return getDict(spaCategoryApi)
    }
    
    public func sendSpaOrder(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(spaOrderApi, withData: dataDict)
    }
}

//MARK: House Keeping
extension flServiceController {
    public func sendHousekeepingOrder(dataDict: ObjcDictionary, withImageDatas imageDatas: [AnyObject]) -> ObjcDictionary? {
        return send(houseKeepingOrderApi, withData: dataDict, withImageDatas: imageDatas)
    }
    
    public func getHosuekeepingServices(cusId: String) -> ObjcDictionary? {
        return getDict(housekeepingMainApi)
    }
    
    public func getHosuekeepingOrderHis(cusId: String) -> ObjcDictionary? {
        return getDict(housekeepingOrderHisApi)
    }
}

//MARK: Honeymoon
extension flServiceController {
    public func getCtHoneymoonCategory(cusId: String) -> ObjcDictionary? {
        return getDict(ctHoneymoonCategoryApi)
    }
    
    public func sendCtHoneymoonOrder(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(ctHoneymoonOrderApi, withData: dataDict)
    }
}

//MARK: Language
extension flServiceController {
    public func getLanguage(cusId: String) -> ObjcDictionary? {
        return getDict(languageApi)
    }
}

//MARK: Send Myroom Information
extension flServiceController {
    public func sendMyroomMsgMarkRead(msgId: String?, isRead: Bool) -> ObjcDictionary? {
        return send(myroomMsgSnedMarkReadApi, withData:["id": msgId ?? "", "is_read": isRead])
    }
}

//MARK: Printer
extension flServiceController {
    public func fetchPrinterNewJob(names: String, lastJob: String) -> ObjcDictionary? {
        printerNewJobApi.parameters = [names, lastJob]
        return printerNewJobApi.fetch(false, type:.json, validate: true)
    }
}

//MARK: Log
extension flServiceController {
    public func sendSavePrintQueue(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(logPrintQueueApi, withData: dataDict, type: .json, returnType: .json)
    }
    
    public func sendSavePrintLog(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(logPrintLogApi, withData: dataDict, type: .json, returnType: .json)
    }
    
    public func sendSavePrintSuccess(dataDict: ObjcDictionary) -> ObjcDictionary? {
        return send(logPrintSuccessApi, withData: dataDict, type: .json, returnType: .json)
    }
}

//MARK: API
extension flServiceController {
    public func getStockItemList() -> ObjcDictionary? {
        return stockItemListApi.fetch(true, type: .json, validate: true)
    }
    
    public func getStockItemTransactionList(itemId: String) -> ObjcDictionary? {
        stockItemTransactionListApi.parameters = [itemId]
        return stockItemTransactionListApi.fetch(true, type: .json, validate: true)
    }
    
    public func newStockItemTransaction(itemId: String, amount: NSDecimalNumber) -> ObjcDictionary? {
        let stockData = ["item_id": itemId, "amount": amount]
        let data = ["data": ["stock": stockData] ]
        return send(stockItemNewTransactionApi, withData: data, type: .json, returnType: .json)
    }
    
    public func newStockItem(name: String, unitName: String) -> ObjcDictionary? {
        let stockData = ["name": name, "unit_name": unitName]
        let data = ["data": ["stock": stockData] ]
        return send(stockNewItemApi, withData: data, type: .json, returnType: .json)
    }
    
    public func getCloseShiftPrepare() -> ObjcDictionary? {
        return closeShiftPrepareApi.fetch(true, type: .json, validate: false)
    }

    public func closeShift(name: String) -> ObjcDictionary? {
        closeShiftApi.parameters = [name]
        return closeShiftApi.fetch(true, type: .text)
    }
    
    public func activateLicense(licenseKey: String) -> ObjcDictionary? {
        let data = ["data": ["license_key": licenseKey] ]
        return send(activationWithLicenseApi, withData: data, type: .json, returnType: .json)
    }
}

