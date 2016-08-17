//
//  StaffModalViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/11/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

protocol StaffModalDelegate {
    func save(Staffname staffname:String, password:String, permission:[String]) -> Bool
    func edit(response:flServiceResponse) -> Bool
}


class StaffModalViewController: UIViewController {
    @IBOutlet weak var cashierPermissionSwitch: UISwitch!
    @IBOutlet weak var orderPermissionSwitch: UISwitch!
    @IBOutlet weak var voidPermissionSwitch: UISwitch!
    @IBOutlet weak var managetablePermissionSwitch: UISwitch!
    @IBOutlet weak var printCheckPermissionSwitch: UISwitch!
    @IBOutlet weak var closeShiftPermissionSwitch: UISwitch!
    @IBOutlet weak var stockPermissionSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var orderLabel: UILabel!{
        didSet {
            // Add tap gesture
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(orderLabelTaped(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            orderLabel.addGestureRecognizer(tapGestureRecognizer)
            orderLabel.userInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var voidLabel: UILabel!{
        didSet{
            // Add tap gesture
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(voidLabelTaped(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            voidLabel.addGestureRecognizer(tapGestureRecognizer)
            voidLabel.userInteractionEnabled = true
        }
    }
    
    
    @IBOutlet weak var manageTableLabel: UILabel!{
        didSet{
            // Add tap gesture
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(manageTableTaped(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            manageTableLabel.addGestureRecognizer(tapGestureRecognizer)
            manageTableLabel.userInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var printCheckLabel: UILabel!{
        didSet{
            // Add tap gesture
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(printCheckTaped(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            printCheckLabel.addGestureRecognizer(tapGestureRecognizer)
            printCheckLabel.userInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var cashierLable: UILabel!{
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cashierCheckTaped(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            cashierLable.addGestureRecognizer(tapGestureRecognizer)
            cashierLable.userInteractionEnabled = true
            
        }
    }
    
    @IBOutlet weak var closeShiftLabel: UILabel!{
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeShiftTaped(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            closeShiftLabel.addGestureRecognizer(tapGestureRecognizer)
            closeShiftLabel.userInteractionEnabled = true
            
        }
    }
    
    @IBOutlet weak var stockLabel: UILabel!{
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stockTaped(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            stockLabel.addGestureRecognizer(tapGestureRecognizer)
            stockLabel.userInteractionEnabled = true
            
        }
    }
    
    
    var indexPath:NSIndexPath?
    var isEdit:Bool = false // for check this is Editing staff not a new staff
    var dalegate:StaffModalDelegate?
    var staffData:flStaffData?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initStaff()
    }
    
    func initStaff(){
        if let staff = staffData{
            nameTextField.text = staff.name
            passwordTextField.text = staff.password
            
            voidPermissionSwitch.setOn(staff.perm_void, animated: true)
            managetablePermissionSwitch.setOn(staff.perm_void, animated: true)
            orderPermissionSwitch.setOn(staff.perm_make_order, animated: true)
            printCheckPermissionSwitch.setOn(staff.perm_print_check, animated: true)
            cashierPermissionSwitch.setOn(staff.perm_cashier, animated: true)
            closeShiftPermissionSwitch.setOn(staff.perm_close_shift, animated: true)
            stockPermissionSwitch.setOn(staff.perm_stock, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//REMARK :: There is Action container
extension StaffModalViewController{
    @IBAction func onCancel(sender: AnyObject) {
        //User close pop up
        staffData = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSave(sender: AnyObject) {
        //Check This save for old staff or new create
        switch isEdit {
        case true:
            //Update Staff Data
            var staff = buildStaffData()
            let response = flServiceController.sharedService.updateStaff(staff)
                flLog.info("\(response)")
                
                let result = dalegate?.edit(response)
                if result == true {
                    dismissViewControllerAnimated(true, completion: {
                        
                    })
                }
        case false:
            //Create new staff
            let staff = buildStaffData()
            
            background{
                let response = flServiceController.sharedService.newStaff(staff)
                let result = self.dalegate?.edit(response)
                if result == true {
                    main{
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
            
        default:
            let message = "Has some thing wrong plaese try agian!!";
            main { showAlert("Oh Sorry!!", message: "\(message)") }
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

//Mark:- Build Staff from UI
extension StaffModalViewController{
    func buildStaffData() -> flStaffData{
        let perm_cashier = cashierPermissionSwitch.on, //Mark Error
            perm_close_shift = closeShiftPermissionSwitch.on, //Mark Error
            perm_make_order = orderPermissionSwitch.on, //Mark Error
            perm_manage_table = managetablePermissionSwitch.on,
            perm_print_check = printCheckPermissionSwitch.on,
            perm_stock = stockPermissionSwitch.on,
            perm_void = voidPermissionSwitch.on
        var name="", password=""
        var staff:flStaffData
        
        
        if let nameValue = nameTextField.text{
            name = nameValue
        }
        
        if let passwordValue = passwordTextField.text{
            password = passwordValue
        }
        
        if let staffData = self.staffData{
            staff = staffData
            staff.name = name
            staff.password  = password
            staff.perm_cashier = perm_cashier
            staff.perm_close_shift = perm_close_shift
            staff.perm_make_order = perm_make_order
            staff.perm_manage_table = perm_manage_table
            staff.perm_print_check = perm_print_check
            staff.perm_stock = perm_stock
            staff.perm_void = perm_void
            
            return staff
        }else{
            staff = flStaffData(id: "", staff_id: "", name: name, password: password, perm_cashier:perm_cashier, perm_close_shift: perm_close_shift, perm_make_order: perm_make_order, perm_manage_table: perm_manage_table, perm_print_check: perm_print_check, perm_stock: perm_stock, perm_void: perm_void)
            return staff
        }
    }
}

extension StaffModalViewController{
    func orderLabelTaped(recognizer: UITapGestureRecognizer) {
        orderPermissionSwitch.setOn(!orderPermissionSwitch.on, animated: true)
    }
    
    func voidLabelTaped(recognizer: UITapGestureRecognizer) {
        voidPermissionSwitch.setOn(!voidPermissionSwitch.on, animated: true)
    }
    
    func manageTableTaped(recognizer: UITapGestureRecognizer) {
        managetablePermissionSwitch.setOn(!managetablePermissionSwitch.on, animated: true)
    }
    
    func printCheckTaped(recognizer: UITapGestureRecognizer) {
        printCheckPermissionSwitch.setOn(!printCheckPermissionSwitch.on, animated: true)
    }
    
    func cashierCheckTaped(recognizer: UITapGestureRecognizer) {
        cashierPermissionSwitch.setOn(!cashierPermissionSwitch.on, animated: true)
    }
    
    func closeShiftTaped(recognizer: UITapGestureRecognizer) {
        closeShiftPermissionSwitch.setOn(!closeShiftPermissionSwitch.on, animated: true)
    }
    
    func stockTaped(recognizer: UITapGestureRecognizer){
        stockPermissionSwitch.setOn(!stockPermissionSwitch.on, animated: true)
    }
}



//Remark: Quick setting Action
extension StaffModalViewController{
    @IBAction func quickSetCashier(sender: UIButton) {
        cashierPermissionSwitch.setOn(true, animated: true)
        printCheckPermissionSwitch.setOn(true, animated: true)
        closeShiftPermissionSwitch.setOn(true, animated: true)
    }
    
    @IBAction func quickSetOrder(sender: UIButton) {
        orderPermissionSwitch.setOn(true, animated: true)
        managetablePermissionSwitch.setOn(true, animated: true)
    }
    
    @IBAction func quickSetManager(sender: UIButton) {
        cashierPermissionSwitch.setOn(true, animated: true)
        printCheckPermissionSwitch.setOn(true, animated: true)
        closeShiftPermissionSwitch.setOn(true, animated: true)
        orderPermissionSwitch.setOn(true, animated: true)
        managetablePermissionSwitch.setOn(true, animated: true)
        stockPermissionSwitch.setOn(true, animated: true)
        voidPermissionSwitch.setOn(true, animated: true)
    }
    
    @IBAction func onClear(sender: UIButton) {
        cashierPermissionSwitch.setOn(false, animated: true)
        printCheckPermissionSwitch.setOn(false, animated: true)
        closeShiftPermissionSwitch.setOn(false, animated: true)
        orderPermissionSwitch.setOn(false, animated: true)
        managetablePermissionSwitch.setOn(false, animated: true)
        stockPermissionSwitch.setOn(false, animated: true)
        voidPermissionSwitch.setOn(false, animated: true)
    }
}
