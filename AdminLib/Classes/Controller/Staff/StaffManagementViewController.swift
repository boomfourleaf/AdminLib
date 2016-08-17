//
//  StaffManagementViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/11/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

class StaffManagementViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, StaffModalDelegate{

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 100
        }
    }
    
    var dataSource:[flStaffData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStaffList(){
            self.tableView.reloadData()
            self.dismissPresentedViewController(true)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Navigation
extension StaffManagementViewController{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let destination = segue.destinationViewController as! StaffModalViewController
        let indexPath = sender as! NSIndexPath
        
        if segue.identifier == "Edit staff"{
            let destination = segue.destinationViewController as! ProfileViewController
            if let staffData = dataSource{
                destination.staffData = staffData[indexPath.row]
            }
            
//            let indexPath = sender as! NSIndexPath
//            destination.indexPath = indexPath
//            destination.staffData = dataSource![indexPath.row]
//            destination.isEdit = true
//            destination.dalegate = self
        }
        if segue.identifier == "Add staff segue"{
            let destination = segue.destinationViewController as! StaffModalViewController
            destination.dalegate = self
        }
        
    }
}

// Mark:- Table view dataSource and Cell height setting
extension StaffManagementViewController{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = dataSource {
            if !data.isEmpty{
                return data.count
            }
        }
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Edit staff", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        guard let cell:StaffListTableViewCell = tableView.dequeueReusableCellWithIdentifier("Staff list cell")  as! StaffListTableViewCell else { return UITableViewCell(frame: CGRectZero) }
        
        guard let staffData = dataSource else {
            cell.staffNameLabel?.text = "Loading"
            cell.staffPermissionLabel.text = ""
            return cell
        }
        
        
        cell.backgroundColor = UIColor.grayColor()
        cell.staffNameLabel.text = staffData[indexPath.row].name
        
//        cell.staffPermissionLabel.text = permissionTextBuilder(staffData[indexPath.row])
        return cell
    }
}



//REMARK : ABOUT API CALL
extension StaffManagementViewController{
    func save(Staffname staffname: String, password: String, permission: [String]) -> Bool
    {
        return true
    }
    
    func edit(response: flServiceResponse) -> Bool {
        return processResponse(response)
    }
    
    func fetchStaffList(finished: ()->()) {
        flServerConfigure.shareObject.http = "https"
        flServerConfigure.shareObject.server = "devabf.afourleaf.com"
        
        guard let staffListValue = flServiceController.sharedService.getStaffList() else { return }
        dataSource = staffListValue
        
        for staff in staffListValue {
            flLog.info("\(staff)")
        }
        
        finished()
    }
    
    func processResponse(orderResponse: flServiceResponse) -> Bool{
        switch orderResponse {
        case let .error(error, data, action):
            main{ showFailedWithError(error) }
            return false
            
        case let .success(success):
            main { showAlert("Success", message: "\(success)") }
            background {
                self.fetchStaffList {
                    main {
                        self.tableView.reloadData()
                    }
                }
            }
            return true
        }
    }
}



