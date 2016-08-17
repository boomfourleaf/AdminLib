//
//  TableManagementViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/13/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

class TableManagementViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    var tableNameData:[flTableNameData]!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


//Remark:- TableView dataSource
extension TableManagementViewController{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let tableNameData = tableNameData{
            return tableNameData.count
//        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        if let tableNameData = tableNameData{
            flLog.info("indexPath \(indexPath.section) \(indexPath.row)")
            
            guard let cell = tableView.dequeueReusableCellWithIdentifier("table list cell") else { return UITableViewCell(frame: CGRectZero) }
            
            cell.textLabel?.text = tableNameData[indexPath.row].table_name
            return cell
//        }
        return UITableViewCell(frame: CGRectZero)
    }
}
