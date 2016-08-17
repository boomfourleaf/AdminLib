//
//  AppSyncInfrastructurePreparation.swift
//  Pods
//
//  Created by Nattapon Nimakul on 7/5/2559 BE.
//
//

import Foundation

public struct AppSyncInfrastructurePreparation {
    static func dataAndMediaPaths() -> (appsoPath: String, dataPath: String, imagePath: String) {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let appsoPath = (documentsDirectory as NSString).stringByAppendingPathComponent("Appso")
        let dataPath = (appsoPath as NSString).stringByAppendingPathComponent("Data")
        let imagePath = (appsoPath as NSString).stringByAppendingPathComponent("Image")
        
        return (appsoPath: appsoPath, dataPath: dataPath, imagePath: imagePath)
    }
    
    public static func createDataAndMediaDirectoryIfNeed() {
        let paths = dataAndMediaPaths()
        
        createDirectoryAtPath(paths.appsoPath)
        createDirectoryAtPath(paths.dataPath)
        createDirectoryAtPath(paths.imagePath)
    }
    
    public static func createDirectoryAtPath(destinationPath: String) {
        if !AppsoFileManager.isExist(destinationPath) {
            flLog.info("\nCreating Path \(destinationPath)")
            do {
                // Create Appso Path
                try NSFileManager.defaultManager().createDirectoryAtPath(destinationPath, withIntermediateDirectories: false, attributes: nil)
                if AppsoFileManager.isExist(destinationPath) {
                    flLog.info("successfully Created Path \(destinationPath)")
                } else {
                    flLog.error("Failed to verifty creating path \(destinationPath)")
                }
                
                
                
            } catch let error as NSError {
                flLog.error("Failed to create path \(destinationPath) with error \(error.localizedDescription) \n")
            }
        }
    }
    
    public static func isInfrastructureReady() -> Bool {
        return AppsoFileManager.isExist(dataAndMediaPaths().dataPath)
            && AppsoFileManager.isExist(dataAndMediaPaths().imagePath)
    }
    
    public static func alertInfrastructureNotReady(viewController: UIViewController) {
        let alertController = UIAlertController(title: "App Sync not ready!", message: "Add AppSyncInfrastructurePreparation.createDataAndMediaDirectoryIfNeed() in your App delegate didFinishLaunchingWithOptions", preferredStyle: .Alert)
        
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in }
        alertController.addAction(cancelAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}
