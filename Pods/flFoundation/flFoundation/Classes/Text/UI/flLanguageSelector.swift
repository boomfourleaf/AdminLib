//
//  flLanguageSelector.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/19/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit

public class flLanguageSelector {
    public var picker: flPickerVC?
    
    public init() {
        
    }

    public func createNewPicker() {
        let vc = LanguageStoryboard.newVC(.picker)
        vc.items = flLanguageController.sharedService.getLangListDisplayText()
        vc.itemIndex = flLanguageController.sharedService.selectedIndex
        vc.delegate = self
        vc.title = localize("Language")
        
        picker = vc
    }
    
    public func removePicker() {
        picker = nil
    }
    
    public func display(inViewController parentViewControlelr: UIViewController, atBarButtonItem barButtonItem: UIBarButtonItem) {
        createNewPicker()
        
        guard let pickerValue = picker else { return }
        // Show as Pop Over
        pickerValue.popoverPresentationController?.backgroundColor = UIColor(rgb: (120, 120, 120))
        pickerValue.modalPresentationStyle = .Popover
        guard let popover = pickerValue.popoverPresentationController else { return }
        popover.barButtonItem = barButtonItem
        
        parentViewControlelr.presentViewController(pickerValue, animated: true, completion: nil)
    }
}

//MARK: Language Selector FL Picker VC
extension flLanguageSelector: flPickerVCDelegate {
    public func pickerDidSelect(row: Int, item: String) {
        setLangIndex(row)
    }
    
    public func pickerDidHitDone() {
        // Do nothing
        removePicker()
    }
    
    public func setLangIndex(index: Int) -> Bool {
        let langCon = flLanguageController.sharedService
        if index != langCon.selectedIndex {
            langCon.selectedIndex = index
            return true
        }
        
        return false
    }
}
