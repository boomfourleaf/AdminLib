//
//  flServiceController+Table.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/22/2559 BE.
//
//

import Foundation
import SwiftyJSON


extension flServiceController {
    public func getTableList() -> [(flTableZoneData, [flTableNameData])]? {
        guard let downlaodedData = flTableListApi().fetch(true, type: .json, validate: true) else { return nil }
        
        var outpus = [(flTableZoneData, [flTableNameData])]()
        for tableZoneData in JSON(downlaodedData)[API_ROOT_DATAS].arrayValue {
            if let tableZone = flTableZoneData.parse(json: tableZoneData) {
                let tableNames = tableZoneData["items"].arrayValue.flatMap(flTableNameData.parse)
                
                outpus.append( (tableZone, tableNames) )
            }
        }
        
        return outpus
    }
    
    // Update
    public func updateTableZone(data: flTableZoneData) -> flServiceResponse {
        return send(flTableUpdateZoneApi(), data: data)
    }
    
    public func updateTableName(data: flTableNameData) -> flServiceResponse {
        return send(flTableUpdateNameApi(), data: data)
    }
    
    
    // New
    public func newTableZone(data: flTableZoneData) -> flServiceResponse {
        return send(flTableNewZoneApi(), data: data)
    }
    
    public func newTableName(data: flTableNameData) -> flServiceResponse {
        return send(flTableNewNameApi(), data: data)
    }
    
    
    // Delete
    public func deleteTableZone(data: flTableZoneData) -> flServiceResponse {
        return send(flTableDeleteZoneApi(), data: data)
    }
    
    public func deleteTableName(data: flTableNameData) -> flServiceResponse {
        return send(flTableDeleteNameApi(), data: data)
    }
}
