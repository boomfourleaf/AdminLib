//
//  RightViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/7/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

class RightViewController: UIViewController {

    @IBOutlet weak var receiptImageView: UIImageView!
    var flReceipt:flReceiptData?
    var delegate:ReceiptView?
    
    lazy var previewReceipt = flPrinterPreviewReceipt()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension RightViewController{
    //Handler
    func handler(notif: NSNotification) {
        print("MyNotification was handled");
        print("userInfo: \(notif.userInfo)");
    }
    
    func eiei(text:String) {
        print(text)
    }
    func renderReciept(receitpData:flReceiptData){
        background{
            let reciptImage = self.previewReceipt.renderImageWithflReceiptData(receitpData)
            main{
                self.receiptImageView.image = reciptImage
            }
        }
    }
}

