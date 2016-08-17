//
//  StaffDeleteViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/22/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import Foundation
import flFoundation

//Remark Delete cell in tableView
extension StaffManagementViewController{
    // Override to support conditional editing of the table view.
    // This only needs to be implemented if you are going to be returning NO
    // for some items. By default, all items are editable.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete", handler: {
            (action, indexPath) -> Void in
            runInHighPriority {
                [unowned self] in
                guard let staffListValue = self.dataSource,
                    let staff = staffListValue[safe: indexPath.row] else { return }
                
                let response = flServiceController.sharedService.deleteStaff(staff)
                flLog.info("\(response)")
                
                self.processDeleteResponse(response, indexPath: indexPath)
                
                main { self.tableView?.editing = false }
            }
        })
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        flLog.info("begin")
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //empty on purpose
        flLog.info("begin")
    }
}

//MARK: Delte Aniamtion
extension StaffManagementViewController {
    func processDeleteResponse(orderResponse: flServiceResponse, indexPath: NSIndexPath) {
        switch orderResponse {
        case let .error(error, data, action):
            main{ showFailedWithError(error) }
            
        case let .success(success):
            main {
                self.tableView.beginUpdates()
                self.dataSource?.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.endUpdates()
            }
        }
    }
}