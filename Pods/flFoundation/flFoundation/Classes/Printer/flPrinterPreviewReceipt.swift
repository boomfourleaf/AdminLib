//
//  flPrinterPreviewReceipt.swift
//  flPrinter
//
//  Created by Nattapon Nimakul on 6/6/2559 BE.
//  Copyright © 2559 Aspsolute Soft. All rights reserved.
//

import Foundation

public class flPrinterPreviewReceipt {
    public var logoImage: UIImage?
    public var siteName = ""
    public var address = ""
    public var tableName = ""
    public var billingId = ""
    public var dateTimeText = ""
    public var staff = ""
    public var guestAmountText = ""
    
    public var items = [(name: String, price: String)]()
    
    public var subtotal: String?
    public var discount: (label: String, value: String)?
    public var serviceCharge: (label: String, value: String)?
    public var vat: (label: String, value: String)?
    public var misc: String?
    public var total: String?
    
    public var payment: (label: String, value: String)?
    public var change: (label: String, value: String)?
    
    public var tail: String?
    
    public init() {
        
    }
    
    public func renderImage() -> UIImage {
        let preview = flPrinterPreview()
        
        // Logo
        if let logoImageValue = logoImage {
            preview.printImage(logoImageValue)
        }
        
        // Header
        preview.printHeadName(siteName)
        preview.printSmallText(address)
        preview.printUnderLine()
        preview.printTexts(" ", rightText: " ", font: "H16")
        preview.printHeaderText(tableName, rightText: billingId)
        preview.printUnderLine()
        preview.printSmallText(dateTimeText, rightText: staff)
        preview.printSmallText("Guest: " + guestAmountText)
        preview.feed(50)
        
        // Item
        for item in items {
            preview.printNormalText(item.name, rightText: item.price)
        }
        preview.feed(50)
        
        // Total
        if let subtotalValue = subtotal {
            preview.printNormalTextSmaller("Subtotal", rightText: subtotalValue)
        }
        if let discountValue = discount {
            preview.printNormalTextSmaller(discountValue.label, rightText: discountValue.value)
        }
        if let serviceChargeValue = serviceCharge {
            preview.printNormalTextSmaller(serviceChargeValue.label, rightText: serviceChargeValue.value)
        }
        if let vatValue = vat {
            preview.printNormalTextSmaller(vatValue.label, rightText: vatValue.value)
        }
        if let miscValue = misc {
            preview.printNormalTextSmaller("Misc.", rightText: miscValue)
        }
        preview.printUnderLine()
        if let totalValue = total {
            preview.printBigText("Total", rightText: totalValue)
        }
        preview.feed(100)
        
        // Payment
        if let paymentValue = payment {
            preview.printNormalTextSmaller(paymentValue.label, rightText: paymentValue.value)
        }
        if let changeValue = change {
            preview.printNormalTextSmaller(changeValue.label, rightText: changeValue.value)
        }
        
        // Ending
        if let tailValue = tail {
            preview.printSmallText(tailValue, center: true)
        }
        preview.feed(100)
        
        return preview.exportToImage()
    }
    
    public func exampleSetup() {
        // Logo
        logoImage = UIImage(named: "logo.bmp")
        
        // Header
        siteName = "Sunrise Tropical"
        address = "Reservation : table@sunrisetropical.com\n" +
            "FB: Facebook.com/sunrisetropical\n" +
            "W: http://www.sunrisetropical.com\n" +
            "T: 08..."
        
        tableName = "TABLE 2"
        billingId = "#00611"
        dateTimeText = "02-Jun-2016 04:06PM"
        staff = "#001 Manager"
        guestAmountText = "1"
        
        // Item
        items = [
            (name: "2  #   FRESH JUICE", price: "140.00"),
            (name: "1  #   FRESH JUICE NO ICE", price: "80.00"),
            (name: "1  #   COKE", price: "40.00"),
        ]
        
        // Total
        subtotal = "260.00"
        discount = (label: "Discount 20%", value: "-52.00")
        serviceCharge = (label: "Service charge", value: "20.80")
        vat = (label: "Vat 7%", value: "16.02")
        misc = "0.18"
        total = "245.00"
        
        // Payment
        payment = (label: "Cash", value: "500.00")
        change = (label: "Change", value: "255.00")
        
        // Ending
        tail = "Thank you."
    }
}
