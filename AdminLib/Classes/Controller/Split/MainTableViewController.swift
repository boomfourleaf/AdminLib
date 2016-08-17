//
//  MainTableViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/25/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import BetterBaseClasses


public class MainTableViewController: UITableViewController, UISplitViewControllerDelegate {

    var dataSource:[Section] = []{
        didSet{
//            initMenuDatasource()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuDatasource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource[section].sectionMember.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = dataSource[indexPath.section].sectionMember[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            switch indexPath.row {
            case 0: break
//                performSegueWithIdentifier("Manage Menu", sender: nil)
            case 1:
                performSegueWithIdentifier("Table Setting", sender: nil)
            case 2:
                performSegueWithIdentifier("Staff Setting", sender: nil)
            default:
                break
            }
        }
        
        if indexPath.section == 1{
            switch indexPath.row {
            case 0: break
//                performSegueWithIdentifier("Table Setting", sender: nil)
            case 1:
                performSegueWithIdentifier("Receipt Setting", sender: nil)
            default:
                break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "red" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController
//                controller!.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller!.navigationItem.leftItemsSupplementBackButton = true
//            }
//        } else if segue.identifier == "blue" {
//            let controller = (segue.destinationViewController as! UINavigationController).topViewController
//            controller!.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//            controller!.navigationItem.leftItemsSupplementBackButton = true
//        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MainTableViewController{
    func initMenuDatasource(){
        let section1 = Section(title: "Section 1", member: ["Menu","Table","Staff"])
        let section2 = Section(title: "Section 2", member: ["Discount","Recipt(VATService)"])
        let section3 = Section(title: "Section 3", member: ["Admin","Email Report"])
        let section4 = Section(title: "Section 3", member: ["Printer"])
        dataSource.append(section1)
        dataSource.append(section2)
        dataSource.append(section3)
        dataSource.append(section4)

    }
}
    