//
//  RecieptTableViewCellProtocal.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/4/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import Foundation

enum flReceiptDataType{
    case ImageLogo, RestaurantName, Address, Tail, Vat, VatShow, ServiceCharge, ServiceChargeShow, Misc, MiscMode, None
}

protocol RecieptTableViewCellProtocal{
    var state:flReceiptDataType! { get set }
}