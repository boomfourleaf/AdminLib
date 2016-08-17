//
//  flServiceController+Receipt.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/28/2559 BE.
//
//

import Foundation
import SwiftyJSON


extension flServiceController {
    // Get
    public func getReceipt() -> flReceiptData? {
        guard let downlaodedData = flReceiptGetApi().fetch(true, type: .json, validate: true) else { return nil }
        let receipt = flReceiptData.parse(json: JSON(downlaodedData)[API_ROOT_DATAS])
        return receipt
    }

    // Update
    public func updateReceipt(data: flReceiptData, logo: UIImage) -> flServiceResponse {
        return send(flReceiptUpdateApi(), data: data, withImages: [logo])
    }
}
