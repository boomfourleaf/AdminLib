//
//  StockItemManagementVC.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/26/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit
import SwiftyJSON

class StockItemManagementVC: flVC {
    var dataArr: [AnyObject]?

    @IBOutlet weak var tableView: UITableView!
    
    var itemId = "0"

    override func viewDidLoad() {
        splitViewController?.preferredDisplayMode = .AllVisible
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        flLog.info("viewWillAppear")
    }
    
    // Step 1
    override func downloadFile() {
        if let data = service.getStockItemTransactionList(itemId) {
            let dataJson = JSON(data)
            if let datas = dataJson["datas"].arrayObject {
                dataArr = datas
                readFile()
            }
            flLog.info("dataJson \(dataJson)")
        }
        flLog.info("log")
    }
    
    // Step 2
    override func readFile() {
        flLog.info("log")
        main {
            self.initData()
        }
    }
    
    // Step 3
    override func initData() {
        flLog.info("log")
        tableView.reloadData()
    }
}

//MARK: Table Datasource & Delegate
extension StockItemManagementVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Config.TRANSACTION_CELL_ID) as? StockItemTransactionCell
        if let dataArrValue = dataArr {
            let data = JSON(dataArrValue[indexPath.row])
            cell?.dateLabel.text = data["date"].stringValue
            cell?.amountLabel.text = data["amount"].stringValue
        }
        return cell!
    }
}

//MARK: Configure
extension StockItemManagementVC {
    struct Config {
        static let TRANSACTION_CELL_ID = "Transaction Cell"
    }
}

//MAKR: Event
extension StockItemManagementVC {
    @IBAction func hitAdd(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add", message: "เพิ่ม/ลด จำนวน", preferredStyle: .Alert)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in

        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Amount"
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            runInHighPriority {
                if let amountTextField = alertController.textFields?.first {
                    if let amountText = amountTextField.text {
                        self.service.newStockItemTransaction(self.itemId, amount: dec(amountText))

                        // Update Transaction
                        runInHighPriority { self.downloadFile() }

                        // Update Item List
                        main { self.reloadItemListOnMasterView() }
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

//MARK: Item List (Master View)
extension StockItemManagementVC {
    func reloadItemListOnMasterView() {
        if let nav = splitViewController?.viewControllers.first as? UINavigationController {
            if let stockSelectorVC = nav.viewControllers.first as? StockItemSelectorVCDataControlProtocol {
                stockSelectorVC.reloadData()
            }
        }
    }
}
