//
//  ReciptLeftViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/1/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation
import WDImagePicker

class ReciptLeftViewController: UIViewController, UINavigationControllerDelegate, WDImagePickerDelegate{

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 44
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    
    var delegate:ReceiptModel!
    
//    let imagePicker = UIImagePickerController()
    var imagePicker = WDImagePicker()
    private var popoverController: UIPopoverController!
    private var imagePickerController: UIImagePickerController!

    var image:UIImageView?
    var currentEditngIndexPath:NSIndexPath?
    var dataSource:flReceiptData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchReceipt { receipt in
            main {
                self.dataSource = receipt
                self.tableView.reloadData()
                
                // Send Data To Right View
                
                Loading.shareInstance.dissmissLoading()
                self.updateReceiptRightView()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func fetchReceipt(finished: (flReceiptData)->()) {
        flServerConfigure.shareObject.http = "https"
        flServerConfigure.shareObject.server = "devabf.afourleaf.com"
        main{
         Loading.shareInstance.showLoding(self)
        }
        background {
            guard let receiptValue = flServiceController.sharedService.getReceipt() else {
                return
            }
            flLog.info("\(receiptValue)")
            finished(receiptValue)
        }
    }
}

//Remark:- TableView dataSource
extension ReciptLeftViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource{
            return 7
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let receipt = dataSource{
            switch indexPath.row {
            case 0:
                return logoImageCell(tableView, cellForRowAtIndexPath: indexPath, textTitle: "Logo Image", state: .ImageLogo, initValue: receipt.logo)
            case 1:
                return textFieldCell(tableView, cellForRowAtIndexPath: indexPath, textTitle: "Restaurent Name", state: .RestaurantName, initValue: receipt.name)
            case 2:
                return textViewCell(tableView, cellForRowAtIndexPath: indexPath, textTitle: "Address", state: .Address, initValue: receipt.address)
            case 3:
                return textViewCell(tableView, cellForRowAtIndexPath: indexPath, textTitle: "Tail", state: .Tail, initValue: receipt.tail_bill)
            case 4:
                return SwitchPrototype(tableView, cellForRowAtIndexPath: indexPath, textTitle: "Vat", state: .Vat, initValue: receipt.show_vat)
            case 5:
                return SwitchPrototype(tableView, cellForRowAtIndexPath: indexPath, textTitle: "Service Charge", state: .ServiceCharge, initValue: receipt.show_service_charge)
            case 6:
                return SwitchPrototype(tableView, cellForRowAtIndexPath: indexPath, textTitle: "Misc", state: .Misc, initValue: receipt.show_misc)
            default:
                return UITableViewCell(frame: CGRectZero)
            }
        }
        return UITableViewCell(frame: CGRectZero)
    }
}


//Mark:- Cell Prototype Setup
extension ReciptLeftViewController{
    func SwitchPrototype(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, textTitle title: String, state: flReceiptDataType, initValue: Bool?) -> LabelAndSwitchTableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("label and switch cell") as! LabelAndSwitchTableViewCell
        cell.delegate = self
        cell.state = state
        
        // Do any additional setup after loading the view.
        cell.titleTextLabel.text = title
        if let value = initValue{
            cell.valueSwitch.on = value
        }

        return cell
    }
    
    func textViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, textTitle title:String, state: flReceiptDataType, initValue: String?) -> LabelAndTextViewTableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("label textview cell") as! LabelAndTextViewTableViewCell
        cell.delegate = self
        cell.state = state
        
        // Do any additional setup after loading the view.
        cell.textTitleLabel.text = title
        if let value = initValue{
           cell.textView.text = value
        }
        return cell
    }
    
    func textFieldCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, textTitle title:String, state:flReceiptDataType, initValue: String?) -> LabelAndTextFieldTableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("label and textField cell") as! LabelAndTextFieldTableViewCell
        cell.delegate = self
        cell.state = state
        
        
        // Do any additional setup after loading the view.
        cell.textTitleLabel.text = title
        if let value = initValue{
            cell.valueTextField.text = value
        }
        return cell
    }
    
    func logoImageCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, textTitle title:String, state: flReceiptDataType, initValue: UIImage?)-> LogoImageTableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("logo Image cell") as! LogoImageTableViewCell
        cell.state = state
        
        // Do any additional setup after loading the view.
        cell.textTitleLabel.text = title
        if let value = initValue{
            cell.logoImage!.image = value
        }
        return cell
            
    }
}


extension ReciptLeftViewController{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
         let cell = tableView.cellForRowAtIndexPath(indexPath) as! RecieptTableViewCellProtocal
        
        if let state = cell.state {
            switch state{
            case .ImageLogo:
                self.imagePicker = WDImagePicker()
                self.imagePicker.cropSize = CGSizeMake(540, 114)
                self.imagePicker.resizableCropArea = true
                self.imagePicker.delegate = self
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    self.popoverController = UIPopoverController(contentViewController: self.imagePicker.imagePickerController)
                    self.presentViewController(self.imagePicker.imagePickerController, animated: true, completion: nil)

                } else {
                    self.presentViewController(self.imagePicker.imagePickerController, animated: true, completion: nil)
                }
                
            default:
                break
            }
        }
        
        // Set  indexPath for dynamic edit row
        currentEditngIndexPath = indexPath
    }
}


// MARK: - UIImagePickerControllerDelegate Methods
extension ReciptLeftViewController{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            if let indexPath = currentEditngIndexPath{
                eventHandler(flReceiptDataType.ImageLogo, value: pickedImage)
//            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}



//WDImagePicker
extension ReciptLeftViewController{
    func imagePicker(imagePicker: WDImagePicker, pickedImage: UIImage) {
        eventHandler(flReceiptDataType.ImageLogo, value: pickedImage)
        self.hideImagePicker()
    }
    
    func hideImagePicker() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController.dismissPopoverAnimated(true)
        } else {
            self.imagePicker.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        eventHandler(flReceiptDataType.ImageLogo, value: image)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController.dismissPopoverAnimated(true)
            picker.dismissViewControllerAnimated(true, completion: nil)
        } else {
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//Event Handler
extension ReciptLeftViewController: LabelAndSwitchTableViewCellDelegate{
    func didTappedSwitch(cell: LabelAndSwitchTableViewCell, value: Bool) {
        currentEditngIndexPath = tableView.indexPathForCell(cell)
        eventHandler(cell.state, value: value)
    }
}

extension ReciptLeftViewController: LabelAndTextFieldTableViewCellDelegate{
    func onSetText(cell:LabelAndTextFieldTableViewCell ,text: String) {
        currentEditngIndexPath = tableView.indexPathForCell(cell)
        eventHandler(cell.state, value: text)
    }
}

extension ReciptLeftViewController: LabelAndTextViewTableViewCellDelegate{
    func onSetTextView(cell: LabelAndTextViewTableViewCell, text: String) {
        currentEditngIndexPath = tableView.indexPathForCell(cell)
        eventHandler(cell.state, value: text)
    }
}