//
//  flRestaurantConfigure.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/20/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

@objc public  enum TableInputMode: Int {
    case TableScroll, TableGrid, TextInput
}

public final class flRestaurantConfigure: NSObject {
    public static var shareObject = flRestaurantConfigure()
    
    public final var maxSplitBill = 25
    public final var zones: [ObjcDictionary]?
    public final var tableInputMode = TableInputMode.TableScroll
    public final var discountPercentLabelStyle = DiscountPercentLabelStyle.SIMPLE
}

extension flRestaurantConfigure {
    public enum DiscountPercentLabelStyle: String {
        case SIMPLE="SIMPLE",
        FULL_DETAIL="FULLDT"
    }
}
