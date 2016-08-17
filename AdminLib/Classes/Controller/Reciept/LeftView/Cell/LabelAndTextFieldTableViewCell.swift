//
//  LabelAndTextFieldTableViewCell.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/1/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit

protocol LabelAndTextFieldTableViewCellDelegate {
    func onSetText(cell:LabelAndTextFieldTableViewCell, text:String)
}

class LabelAndTextFieldTableViewCell: UITableViewCell, RecieptTableViewCellProtocal {
    @IBOutlet weak var textTitleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    var delegate:LabelAndTextFieldTableViewCellDelegate!
    var state:flReceiptDataType!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onEdited(sender: UITextField) {
        if let textValue = sender.text{
            delegate.onSetText(self, text: textValue)
        }
    }
    
    @IBAction func onInputText(sender: UITextField) {
        if let textValue =  sender.text{
//            delegate.onSetText(self, text: textValue)
        }
    }

}
