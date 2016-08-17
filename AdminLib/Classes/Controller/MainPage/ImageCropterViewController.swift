//
//  ImageCropterViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/12/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import Toucan

class ImageCropterViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 50))
        path.addLineToPoint(CGPointMake(50, 0))
        path.addLineToPoint(CGPointMake(100, 50))
        path.addLineToPoint(CGPointMake(50, 100))
        path.closePath()
        
        let resizedAndMaskedImage = Toucan(image: UIImage(named: "coffee")!).resize(CGSize(width: 50
            , height: 50)).maskWithPath(path: path)
        image.image = resizedAndMaskedImage.image
        
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
