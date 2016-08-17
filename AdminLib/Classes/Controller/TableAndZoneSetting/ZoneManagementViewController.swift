//
//  TableManagementViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/11/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

class ZoneManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var tableZoneList: [(flTableZoneData, [flTableNameData])]?
    
    var snapShot: UIView?
    var sourceIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = localize("Table Management")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        super.viewDidLoad()
        fetchTableList { tableZoneList in
            main {
                self.tableZoneList = tableZoneList
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchTableList(finished: (tableZoneList: [(flTableZoneData, [flTableNameData])])->()) {
        flServerConfigure.shareObject.http = "https"
        flServerConfigure.shareObject.server = "devabf.afourleaf.com"
        
        background {
            guard let tableListValue = flServiceController.sharedService.getTableList() else { return }
            
            for staff in tableListValue {
                flLog.info("\(staff)")
            }
            
            finished(tableZoneList: tableListValue)
        }
    }
}

// MARK: - Pass data to destination view
extension ZoneManagementViewController{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = sender {
            if segue.identifier == "table list segue"{
                let destination:TableManagementViewController = segue.destinationViewController as! TableManagementViewController
                
                if let tableNameData = tableZoneList{
                    destination.title = "\(tableNameData[indexPath.row].0.zone)"
//                    print(tableNameData[indexPath.row])
                    destination.tableNameData = tableNameData[indexPath.row].1
                }
                
                if let tableZoneListValue = tableZoneList,
                    cell = sender as? UITableViewCell,
                    tableZone = tableZoneList?[safe: indexPath.row]?.0,
                    tableNameList = tableZoneList?[safe: indexPath.row]?.1{
                        destination.title = "\(tableZone.zone)"
                        destination.tableNameData = tableNameList
                }
            }
        }
    }
}


//Remark:- TableView dataSouce
extension ZoneManagementViewController{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableZoneListValue = tableZoneList {
            return tableZoneListValue.count
        } else {
            return 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        guard let cell:TableManagementTableViewCell = tableView.dequeueReusableCellWithIdentifier("Zone list cell") as! TableManagementTableViewCell else { return
                UITableViewCell(frame: CGRectZero) }
        
        guard let tableZoneListValue = tableZoneList else {
            cell.zoneNameLabel?.text = "Loading..."
            return cell
        }
        
        flLog.info("indexPath \(indexPath.section) \(indexPath.row)")
        cell.zoneNameLabel.text = tableZoneListValue[safe: indexPath.row]?.0.zone
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        addLongGestureRecognizerForTableView()
        performSegueWithIdentifier("table list segue", sender: indexPath)
    }
}






//Remark:- About Move index via addLongGestureRecognizerForTableView
extension ZoneManagementViewController{
//    // Determine whether a given row is eligible for reordering or not.
//    func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool
//    {
//        return true;
//    }
//    
//    // Process the row move. This means updating the data model to correct the item indices.
//    func tableView(tableView: UITableView!, moveRowAtIndexPath sourceIndexPath: NSIndexPath!, toIndexPath destinationIndexPath: NSIndexPath!)
//    {
////        let item : String = tableZoneList[sourceIndexPath.row];
////        
////        tableZoneList.removeAtIndex(sourceIndexPath.row);
////        tableZoneList.insert(item, atIndex: destinationIndexPath.row)
//    }
//    
//    
//    func addLongGestureRecognizerForTableView() {
//        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ZoneManagementViewController.handleTableViewLongGesture(_:)) )
//        tableView.addGestureRecognizer(longGesture)
//    }
//    
//    func handleTableViewLongGesture(sender: UILongPressGestureRecognizer) {
//        let state = sender.state
//        let location = sender.locationInView(tableView)
//        guard let indexPath = tableView.indexPathForRowAtPoint(location) else {
//            return
//        }
//        
//        switch state {
//        case .Began:
//            
//            sourceIndexPath = indexPath
//            guard let cell = tableView.cellForRowAtIndexPath(indexPath) else {
//                return
//            }
//            
//            //Take a snapshot of the selected row using helper method.
//            snapShot = customSnapShotFromView(cell)
//            
//            // Add the snapshot as subview, centered at cell's center...
//            var center = CGPoint(x: cell.center.x, y: cell.center.y)
//            snapShot?.center = center
//            snapShot?.alpha = 0.0
//            tableView.addSubview(snapShot!)
//            UIView.animateWithDuration(0.25, animations: {
//                // Offset for gesture location.
//                center.y = location.y
//                self.snapShot?.center = center
//                self.snapShot?.transform = CGAffineTransformMakeScale(0.95, 0.85)
//                self.snapShot?.alpha = 0.98
//                
//                cell.alpha = 0.0
//                }, completion: { _ in
//                    cell.hidden = true
//            })
//        case .Changed:
//            //            print("Change")
//            guard let snapShot = snapShot else {
//                return
//            }
//            guard let sourceIndexPathTmp = sourceIndexPath else {
//                return
//            }
//            var center = snapShot.center
//            center.y = location.y
//            snapShot.center = center
//            
//            // Is destination valid and is it different from source?
//            if !indexPath.isEqual(sourceIndexPathTmp) {
//                print(snapShot.center)
//                //self made exchange method
//                if let 
//                tableZoneList.moveItem(fromIndex: indexPath.row, toIndex: sourceIndexPathTmp.row)
//                // ... move the rows.
//                tableView.moveRowAtIndexPath(sourceIndexPathTmp, toIndexPath: indexPath)
//                // ... and update source so it is in sync with UI changes.
//                sourceIndexPath = indexPath
//                tableView.reloadData()
//            }
//            
//        default:
//            print("defualt")
//            guard let sourceIndexPathTmp = sourceIndexPath else {
//                return
//            }
//            guard let cell = tableView.cellForRowAtIndexPath(sourceIndexPathTmp) else {
//                return
//            }
//            cell.hidden = false
//            cell.alpha = 0.0
//            
//            UIView.animateWithDuration(0.25, animations: {
//                self.snapShot?.center = cell.center
//                self.snapShot?.transform = CGAffineTransformIdentity
//                self.snapShot?.alpha = 0.0
//                
//                cell.alpha = 1.0
//                }, completion: { _ in
//                    self.sourceIndexPath = nil
//                    self.snapShot?.removeFromSuperview()
//                    self.snapShot = nil
//            })
//        }
//    }
//    
//    func customSnapShotFromView(inputView: UIView) -> UIImageView{
//        // Make an image from the input view.
//        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
//        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        let snapshot = UIImageView(image: image)
//        snapshot.layer.masksToBounds = false
//        snapshot.layer.cornerRadius = 0.0
//        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
//        snapshot.layer.shadowRadius = 5.0
//        snapshot.layer.shadowOpacity = 0.4
//        
//        return snapshot
//    }
}