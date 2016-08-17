//
//  flLicenseScreenVC.swift
//  Dining
//
//  Created by Nattapon Nimakul on 1/14/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import flFoundation

class flLicenseScreenVC: flVC {
    @IBOutlet weak var licenseKeyTextField: UITextField! { didSet { licenseKeyTextField.delegate = self } }
    @IBOutlet weak var activatingLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton! { didSet { continueButton.hidden = true } }
    @IBOutlet weak var licenseBox: UIView! { didSet { licenseBox.hidden = true } }
    @IBOutlet weak var licenseBoxCenterYConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        background { self.activateWithUdid() }
    }
}

//MARK: Event
extension flLicenseScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        background { self.activateLicense(self.licenseKeyTextField.text ?? "") }
        return true
    }
    
    @IBAction func hitContinue() {
        background { self.activateLicense(self.licenseKeyTextField.text ?? "") }
    }
}

//MARK: Activation
extension flLicenseScreenVC {
    func activateWithUdid() {
        if let data = flActivationApi.shareObject.fetch(false, type: .json, validate: true) {
            let dataJson = JSON(data)
            // Activate Success
            if dataJson[API_ACTIVATE_RESULT].stringValue == API_ACTIVATE_RESULT_SUCCESS {
                
                if flServerConfigure.shareObject.updateWithData(data) {
                    main { self.dismissViewControllerAnimated(true, completion: nil) }
                } else {
                    main { showAlert("Error", message: "Please contact FOURLEAF Staff.") }
                }
                
            // Activate Failed (no license found)
            } else {
                main { self.licenseBoxFadeIn() }
            }

        // Server not response
        } else {
            // retry
            flLog.info("retry activateWithUdid")
            background(5.0) { self.activateWithUdid() }
            
            main {
                self.activatingLabel.text = "Activating...\n\nPlease check your Internet connection!"
            }
        }
    }
    
    func activateLicense(licenseKey: String) {
        if let data = service.activateLicense(licenseKey),
            let status = data["status"] as? Int where status == 200 {
            flLog.info("output: \(data)")
            let outputJson = JSON(data)
            if  API_ACTIVATE_RESULT_SUCCESS == outputJson[API_ACTIVATE_RESULT].stringValue {
                
                if flServerConfigure.shareObject.updateWithData(data) {
                    main { self.dismissViewControllerAnimated(true, completion: nil) }
                } else {
                    main { showAlert("Error", message: "Please contact FOURLEAF Staff.") }
                }
            } else {
                main { showAlert("Invalid License Key", message: "Please check your license key.") }
            }
        } else {
            main { showAlert("Can't activate", message: "Please check your Internet or try again later.") }
        }
    }
}

//MARK: Animation
extension flLicenseScreenVC {
    func licenseBoxFadeIn() {
        // License Box
        licenseBox.alpha = 0
        licenseBox.hidden = false
        licenseBoxCenterYConstraint.constant += 70
        licenseBox.layoutIfNeeded()
        
        // Continue Button
        continueButton.alpha = 0
        continueButton.hidden = false
        
        UIView.animateWithDuration(0.75, delay: 0.0, options: .CurveEaseOut, animations: { _ in
            // License Box
            self.licenseBox.alpha = 1
            self.licenseBoxCenterYConstraint.constant -= 70
            self.licenseBox.layoutIfNeeded()
            
            // Activating Label
            self.activatingLabel.alpha = 0
            
            // Continue Button
            self.continueButton.alpha = 1
            }) { _ in
                // Activating Label
                self.activatingLabel.hidden = true
        }
    }
}
