//
//  flNumpadVC.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/16/2559 BE.
//
//

import UIKit

public class flNumpadVC: UIViewController {
    @IBOutlet public var oneButton: UIButton!
    @IBOutlet public var twoButton: UIButton!
    @IBOutlet public var threeButton: UIButton!
    @IBOutlet public var fourButton: UIButton!
    @IBOutlet public var fiveButton: UIButton!
    @IBOutlet public var sixButton: UIButton!
    @IBOutlet public var sevenButton: UIButton!
    @IBOutlet public var eightButton: UIButton!
    @IBOutlet public var nightButton: UIButton!
    @IBOutlet public var zeroButton: UIButton!
    @IBOutlet public var decimalPointButton: UIButton!
    @IBOutlet public var deleteButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let deleteImage = UIImage(named:"back_delete.png", inBundle: FOURLEAFFoundationBundle.mainBundle, compatibleWithTraitCollection: nil)
        
        deleteButton.setImage(deleteImage, forState: .Normal)
    }
}
