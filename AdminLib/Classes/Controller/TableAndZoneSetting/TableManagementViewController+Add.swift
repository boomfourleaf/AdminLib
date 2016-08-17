//
//  TableManagementViewController+Add.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/27/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

extension TableManagementViewController{
    
    func showNewOrEdit(table: flTableNameData?=nil) {
        let title = nil == table ? "Add" : "Edit"
        let message = nil == table ? "Add new table" : table!.table_name
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            runInHighPriority {
                [unowned self] in
                let nameTextField = alertController.textFields![0]
                
                let response: flServiceResponse
                // Edit Table
                if let tableValue = table {
                    let index = self.tableNameData.lazy.indexOf{ $0 == table }!
                    
                    var sendTable = tableValue
                    sendTable.table_name = nameTextField.text!
                    response = flServiceController.sharedService.updateTableName(sendTable)
                    self.processResponseForEdit(response, indexPath: NSIndexPath(forRow: index, inSection: 0), table: sendTable)
                    
                    // New Table
                } else {
                    let table = flTableNameData(
                        id: "",
                        category_id: self.tableNameData[0].category_id,
                        active: true,
                        order: -1,
                        table_name: nameTextField.text!)
                    response = flServiceController.sharedService.newTableName(table)
                    self.processResponseForCreate(response, table: table)
                }
                
                flLog.info("\(response)")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onAddNewTable(sender: AnyObject) {
        showNewOrEdit(nil)
    }
}


extension TableManagementViewController{
    func processResponseForEdit(orderResponse: flServiceResponse, indexPath: NSIndexPath, table: flTableNameData) {
        switch orderResponse {
        case let .error(error, data, action):
            main{ showFailedWithError(error) }
            
        case let .success(success):
            main {
                self.tableView.beginUpdates()
                self.tableNameData[indexPath.row] = table
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
                self.tableView.endUpdates()
            }
        }
    }
    
    func processResponseForCreate(orderResponse: flServiceResponse, table: flTableNameData) {
        switch orderResponse {
        case let .error(error, data, action):
            main{ showFailedWithError(error) }
            
        case let .success(success):
            main {
                //                self.tableView.beginUpdates()
                self.tableNameData.append(table)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableNameData.count-1, inSection: 0)], withRowAnimation: .Automatic)
                //                self.tableView.endUpdates()
            }
        }
    }
    
}
