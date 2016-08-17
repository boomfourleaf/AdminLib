//
//  ReciptLeftViewController+EventHandler.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/1/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import Foundation
import flFoundation


//Remark:- Event Handler
extension ReciptLeftViewController{
    func eventHandler(cell:flReceiptDataType, value:AnyObject?){
        if var reciept = dataSource{
            switch cell{
            case .RestaurantName:
                reciept.name = value as! String
            case .Address:
                reciept.address = value as! String
            case .Tail:
                reciept.tail_bill = value as! String
            case .Vat:
                reciept.show_vat = value as! Bool
            case .ServiceCharge:
                reciept.show_service_charge = value as! Bool
            case .Misc:
                reciept.show_misc = value as! Bool
            case .ImageLogo:
                reciept.logo = value as! UIImage
            default: break
            }
            
            // Update receipt in memory
            self.dataSource = reciept
            
            if let indexPath = currentEditngIndexPath{
                sendUpdate(reloadIndexPath: indexPath)
            }
        }
    }
}

//MARK; Process Response
extension ReciptLeftViewController {
    func sendUpdate(reloadIndexPath reloadIndexPath: NSIndexPath) {
        // Copy data for sending
        
        Loading.shareInstance.showLoding(self)
        
        let sendData = self.dataSource
        runInHighPriority {
            let response = flServiceController.sharedService.updateReceipt(sendData!, logo: sendData!.logo!)
            flLog.info("\(response)")
            
            self.processResponse(response, reloadIndexPath: reloadIndexPath)
            self.updateReceiptRightView()
        }
    }
    
    func processResponse(response: flServiceResponse, reloadIndexPath: NSIndexPath) {
        Loading.shareInstance.dissmissLoading()
        switch response {
            
        case let .error(error, data, action):
            main{ showFailedWithError(error) }
            
        case let .success(success):
            main {
                self.tableView.reloadRowsAtIndexPaths([reloadIndexPath], withRowAnimation: .Fade)
            }

            updateReceiptRightView()
        }
    }
}

//Mark:- Send data to controller
extension ReciptLeftViewController{
    func updateReceiptRightView(){
        delegate?.save(dataSource)
    }
}