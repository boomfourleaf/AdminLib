//
//  flServiceController+Staff.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/21/2559 BE.
//
//

import Foundation
import SwiftyJSON

extension flServiceController {
    public func getStaffList() -> [flStaffData]? {
        guard let downlaodedData = flStaffListApi().fetch(true, type: .json, validate: true) else { return nil }
        let staffList = JSON(downlaodedData)[API_ROOT_DATAS].arrayValue.flatMap(flStaffData.parse)
        return staffList
    }

    public func updateStaff(data: flStaffData) -> flServiceResponse {
        return send(flStaffUpdateApi(), data: data)
    }
    
    public func newStaff(data: flStaffData) -> flServiceResponse {
        return send(flStaffNewApi(), data: data)
    }
    
    public func deleteStaff(data: flStaffData) -> flServiceResponse {
        return send(flStaffDeleteApi(), data: data)
    }
}
