//
//  LogoImageTableViewCell.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/1/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit

class LogoImageTableViewCell: UITableViewCell, RecieptTableViewCellProtocal {
    
    
    @IBOutlet weak var textTitleLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!

        
    var state:flReceiptDataType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


