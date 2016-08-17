//
//  StockItemSelectorVC.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/26/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol StockItemSelectorVCDataControlProtocol {
    func reloadData()
}

class StockItemSelectorVC: flVC {
    var items: [(id: String, name: String, remain: String, unit_name: String)]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        title = "Stock"

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        let datadict = service.getStockItemTransactionList("4")
//        flLog.info("\(datadict)")
//        
//        service.newStockItemTransaction("4", amount: dec(100))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case Config.SHOW_ITEM_MANAGEMENT_SEGUE_ID:
                    if let navController = segue.destinationViewController as? UINavigationController {
                        if navController.viewControllers.count > 0 {
                            if let stockItemManagementVc = navController.viewControllers[0] as? StockItemManagementVC {
                                
                                if let indexPath = sender as? NSIndexPath {
                                    if let itemsValue = items {
                                        let data = itemsValue[indexPath.row]
                                        stockItemManagementVc.title = data.name
                                        stockItemManagementVc.itemId = data.id
                                    }
                                }
                            }
                        }
                    }
                
            default:
                break
            }
        }
    }
}

//MARK: - Network
extension StockItemSelectorVC {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        flLog.info("viewWillAppear")
    }
    
    // Step 1
    override func downloadFile() {
        if let data = service.getStockItemList() {
            items = JSON(data)[API_ROOT_DATAS].arrayValue.map{
                (id:        $0["id"].stringValue,
                name:       $0["name"].stringValue,
                remain:     $0["remain"].stringValue,
                unit_name:  $0["unit_name"].stringValue)
            }
            readFile()
        }
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
extension StockItemSelectorVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Config.ITEM_CELL_ID) as? StockItemSelectorItemCell
        if let itemsValue = items {
            let item = itemsValue[indexPath.row]
            cell?.nameLabel.text = item.name
            cell?.remainLabel.text = item.remain + " " + item.unit_name
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Config.SHOW_ITEM_MANAGEMENT_SEGUE_ID, sender: indexPath)
    }
}

//MAKR: Event
extension StockItemSelectorVC {
    @IBAction func hitClose(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func hitAdd(sender: AnyObject) {
        let alertController = UIAlertController(title: "New Item", message: "เพิ่มรายการใหม่", preferredStyle: .Alert)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Unit Name"
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            runInHighPriority {
                var name: String?
                var unitName: String?
                if let nameTextField = alertController.textFields?.first {
                    name = nameTextField.text
                }
                
                if let unitNameTextField = alertController.textFields?.last {
                    unitName = unitNameTextField.text
                }
                
                if let nameValue = name {
                    if let unitNameValue = unitName {
                        self.service.newStockItem(nameValue, unitName: unitNameValue)
                        
                        // Update Item List
                        runInHighPriority { self.downloadFile() }
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

//MARK: Configure
extension StockItemSelectorVC {
    struct Config {
        static let SHOW_ITEM_MANAGEMENT_SEGUE_ID = "Show Item Detail"
        static let ITEM_CELL_ID = "Item Cell"
    }
}

//MARK: Data Update Protocol
extension StockItemSelectorVC: StockItemSelectorVCDataControlProtocol {
    func reloadData() {
        background {
            self.downloadFile()
        }
    }
}
