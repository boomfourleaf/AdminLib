//
//  LabelAndSwitchTableViewCell.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/1/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

protocol LabelAndSwitchTableViewCellDelegate {
    func didTappedSwitch(cell: LabelAndSwitchTableViewCell, value: Bool)
}

class LabelAndSwitchTableViewCell: UITableViewCell, RecieptTableViewCellProtocal {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    @IBOutlet weak var percentValueTextField: UITextField!
    @IBOutlet weak var modeButton: UIButton!
    
    var state:flReceiptDataType!
    
    var delegate:LabelAndSwitchTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        percentValueTextField.text = "12%"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitch(sender: UISwitch) {
        if let state = state{
            delegate.didTappedSwitch(self, value: sender.on)
        }else{
            flLog.warn("state = \(self.state)")
        }
    }
    
    @IBAction func onTouch(sender: AnyObject) {
        print()
    }
    
    @IBAction func onBegin(sender: UITextField) {
        if let textFieldValue = sender.text{
            sender.text = replace(textFieldValue, textValue: "%", replaceWith: "")
        }
    }
    
    @IBAction func onFinishEdit(sender: UITextField) {
        if let textField =  sender.text{
            sender.text = textField+"%"
        }
    }
    
    func replace(sentence:String, textValue:String ,replaceWith newString:String) -> String{
    
        let text = (sentence as NSString).stringByReplacingOccurrencesOfString(textValue, withString: newString)
        return text
    }
    
    @IBAction func onTouchMode(sender: UIButton) {
        sender.setTitle("Touched", forState: .Normal)
    }
}


