//
//  LabelAndTextViewTableViewCell.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/1/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit

protocol LabelAndTextViewTableViewCellDelegate {
    func onSetTextView(cell:LabelAndTextViewTableViewCell, text:String)
}

class LabelAndTextViewTableViewCell: UITableViewCell, RecieptTableViewCellProtocal {
    
    @IBOutlet weak var textTitleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var delegate:LabelAndTextViewTableViewCellDelegate!
    var state:flReceiptDataType!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension LabelAndTextViewTableViewCell: UITextViewDelegate{
    func textViewDidEndEditing(textView: UITextView) {
        if let value = textView.text{
            delegate.onSetTextView(self, text: value)
        }
    }
}
