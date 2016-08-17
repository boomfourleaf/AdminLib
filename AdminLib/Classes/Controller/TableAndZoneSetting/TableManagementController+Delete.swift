//
//  TableManagementController+Delete.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/27/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

extension TableManagementViewController{
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete", handler: {
            (action, indexPath) -> Void in
            runInHighPriority {
                [unowned self] in
                guard let tableNameListValue = self.tableNameData,
                    let tableName = tableNameListValue[safe: indexPath.row] else { return }
                
                let response = flServiceController.sharedService.deleteTableName(tableName)
                flLog.info("\(response)")
                
                self.processDeleteResponse(response, indexPath: indexPath)
                
                main { self.tableView?.editing = false }
            }
        })
        deleteAction.backgroundColor = UIColor.redColor()
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: {
            (action, indexPath) -> Void in
            runInHighPriority {
                [unowned self] in
                
                guard let tableNameListValue = self.tableNameData,
                    let tableName = tableNameListValue[safe: indexPath.row] else { return }
                
                main { self.showNewOrEdit(tableName) }
                main { self.tableView?.editing = false }
            }
        })
        editAction.backgroundColor = UIColor.blueColor()
        
        return [deleteAction, editAction]
    }
}

extension TableManagementViewController {
    func processDeleteResponse(orderResponse: flServiceResponse, indexPath: NSIndexPath) {
        switch orderResponse {
        case let .error(error, data, action):
            main{ showFailedWithError(error) }
            
        case let .success(success):
            main {
                self.tableView.beginUpdates()
                self.tableNameData?.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.endUpdates()
            }
        }
    }
}