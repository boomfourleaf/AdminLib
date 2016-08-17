//
//  flReceiptDateExtension.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/8/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import Foundation
import flFoundation



extension flPrinterPreviewReceipt{
    func renderImageWithflReceiptData(receipt: flReceiptData) -> UIImage{
        let preview = flPrinterPreview()
        
        setUpData()
        
        //Logo
        if let logoImageValue = receipt.logo{
            preview.printImage(logoImageValue)
        }
        
        //Header
        preview.printHeadName(receipt.name)
//        preview.printHeadName(receipt.address)
        preview.printTexts(receipt.address, rightText: " ", font: "H16")
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
//        if let tailValue = receipt.tail_bill {
            preview.printSmallText(receipt.tail_bill, center: true)
//        }
        preview.feed(100)

        
        return preview.exportToImage()
    }
}



extension flPrinterPreviewReceipt{
    typealias  itemsType = (name: String, price: String)
    typealias  itemsPriceDoubleType = (name: String, price: Double)
    
    func build(receipt: flReceiptData){
        let preview = flPrinterPreview()
        
        background{
            print("DEDSET")
            var total = 0.00
            var discount = 20.00 //20.00%
            var totalVat = 0.0
            var totalService = 0.0
            var totalMisc = 0.0
            var totalPrice = 0.0
            let tableName = "TABLE 2"
            let billingId = "#00611"
            let dateTimeText = "02-Jun-2016 04:06PM"
            let staff = "#001 Manager"
            let guestAmountText = "1"
            
            //Logo
            if let logoImageValue = receipt.logo{
                preview.printImage(logoImageValue)
            }
            
            //Header
            preview.printHeadName(receipt.name)
            preview.printHeadName(receipt.address)
            preview.printUnderLine()
            preview.printTexts(" ", rightText: " ", font: "H16")
            preview.printHeaderText(tableName, rightText: billingId)
            preview.printUnderLine()
            preview.printSmallText(dateTimeText, rightText: staff)
            preview.printSmallText("Guest: " + guestAmountText)
            preview.feed(50)
        }
    }

    func setUpData(){
        setPrice()
        setHeader()
        setItemList()
    }
    
    func setPrice(){
//        var total = 0.00
        var discount = 20.00 //20.00%
        var totalVat = 0.0
        var totalService = 0.0
        var totalMisc = 0.0
        var totalPrice = 0.0
        vat = (label: "VAT 7%", value: "7.0")
        serviceCharge = (label: "Service", value: "10.0")
        misc = "0.23"
        subtotal = "100.00"
        total = "127.00"
    }
    
    func setHeader(){
        tableName = "TABLE 2"
        billingId = "#00611"
        dateTimeText = "02-Jun-2016 04:06PM"
        staff = "#001 Manager"
        guestAmountText = "1"
    }
    
    func setItemList(){
        let items:[itemsPriceDoubleType] =
            [(name:"1  #   TOM YUM KUNG",price:50.0),
             (name:"1  #   RICE", price:10.0),
             (name:"1  #   ORANGE JUICE", price:40.0)
        ]
        
        var itemsForShow = items.map{ item  in (name: item.name, price:"\(item.price)") }
        if itemsForShow.count != 0 {
            main{
                self.items = itemsForShow
            }
        }
    }
}
