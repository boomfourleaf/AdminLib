
//
//  ZoneAddEditViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/23/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import Foundation
import flFoundation

extension ZoneManagementViewController{
    @IBAction func onAddNew(sender: AnyObject) {
        showNewOrEdit()
    }
}

extension ZoneManagementViewController {
    func showNewOrEdit(tableZone: flTableZoneData?=nil) {
        let title = nil == tableZone ? "Add" : "Edit"
        let message = nil == tableZone ? "Add new zone" : tableZone!.zone
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Zone"
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            runInHighPriority {
                [unowned self] in
                let zoneTextField = alertController.textFields![0]
                
                let response: flServiceResponse
                // Edit Table Zone
                if let tableZoneValue = tableZone {
                    let index = self.tableZoneList!.lazy.map{ $0.0 }.indexOf{ $0 == tableZoneValue }!
                    
                    var sendTableZone = tableZoneValue
                    sendTableZone.zone = zoneTextField.text!
                    response = flServiceController.sharedService.updateTableZone(sendTableZone)
                    self.processResponseForEdit(response, indexPath: NSIndexPath(forRow: index, inSection: 0))
                    
                    // New Table Zone
                } else {
                    let newTableZone = flTableZoneData(
                        id: "",
                        active: true,
                        order: -1,
                        zone: zoneTextField.text!)
                    response = flServiceController.sharedService.newTableZone(newTableZone)
                    self.processResponseForCreate(response, tableZone: newTableZone)
                }
                
                flLog.info("\(response)")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func processResponseForEdit(orderResponse: flServiceResponse, indexPath: NSIndexPath) {
        switch orderResponse {
        case let .error(error, data, action):
            main{ showFailedWithError(error) }
            
        case let .success(success):
            self.fetchTableList { tableZoneList in
                main {
                    self.tableView.beginUpdates()
                    self.tableZoneList = tableZoneList
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    func processResponseForCreate(orderResponse: flServiceResponse, tableZone: flTableZoneData) {
        switch orderResponse {
        case let .error(error, data, action):
            main{ showFailedWithError(error) }
            
        case let .success(success):
            self.fetchTableList { tableZoneList in
                main {
                    self.tableView.beginUpdates()
                    self.tableZoneList = tableZoneList
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: tableZoneList.count-1, inSection: 0)], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                }
            }
        }
    }
}