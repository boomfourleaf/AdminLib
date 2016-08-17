//
//  flPickerVC.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/27/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit

public protocol flPickerVCDelegate: class {
    func pickerDidSelect(row: Int, item: String)
    func pickerDidHitDone()
}

public class flPickerVC: flVC {
    @IBOutlet public weak var picker: UIPickerView!
    @IBOutlet public weak var headTitle: UILabel! { didSet {
        headTitle.text = title
    } }
    
    public var items = [String]()
    public var itemIndex = 0
    public weak var delegate: flPickerVCDelegate?
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        picker.selectRow(itemIndex, inComponent:0, animated:false)
    }
}

//MARK: Event
extension flPickerVC {
    @IBAction public func hitDone(sender: UIBarButtonItem) {
        delegate?.pickerDidHitDone()
    }
}


extension flPickerVC: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < items.count else { return }
        delegate?.pickerDidSelect(row, item: items[row])
    }
}
