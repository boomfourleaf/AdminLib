//
//  ContentSyncer.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/5/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Generic Content Synchonization with Server
///
/// Usage:
///
///     Override downloadFile, getContent, updateContentIfChanged
///
///     Optional Override shouldUpdateContent, contentDidUpdateWithHash
public class ContentSyncer {
    public lazy var downloadQueue:NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.name = "\(self.dynamicType) Download queue"
        flLog.info("downloadQueue \(queue.name)")
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    public lazy var processConentQueue:NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.name = "\(self.dynamicType) Process Content queue"
        flLog.info("processConentQueue \(queue.name)")
        queue.maxConcurrentOperationCount = 1
        return queue

    }()

    public var updateHash = ""
    public var autoUpdateTimer: NSTimer?
    public var autoUpdateInterval = 10
    
    public init() {
        // Init first Content
        self.processContent()
    }
    
    /// Step 1 download Content
    public func downloadFile() {
        
    }
    
    /// Step 2 Get Content
    public func getContent() -> JSON? {
        return nil
    }
    
    
    /// Step 3 Update Content if Changed
    public func updateContentIfChanged(dataJson: JSON) {
        
    }
    
    //MARK: Optional Override
    public func shouldUpdateContent(content: JSON) -> (shouldUpdate: Bool, hash: String) {
        // Update only if content changed
        if let dataUpdateHash = content[API_ROOT_UPDATE_HASH].string {
            return (shouldUpdate: self.updateHash != dataUpdateHash, hash: dataUpdateHash)
        } else {
            return (shouldUpdate: false, hash: "")
        }
    }
    
    public func contentDidUpdateWithHash(hash: String) {
        
    }
}

extension ContentSyncer {
    public final func startSync() {
        if autoUpdateTimer == nil {
            autoUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(autoUpdateInterval), target: self, selector: #selector(downloadFileObjc), userInfo: nil, repeats: true)
        }
    }
    
    public final func stopSync() {
        autoUpdateTimer?.invalidate()
        autoUpdateTimer = nil
    }
}

extension ContentSyncer {
    
    @objc private func downloadFileObjc() {
        downloadFileWithBlock()
    }
    
    private func downloadFileWithBlock() {
        downloadQueue.addOperationWithBlock {
            self.downloadFile()
            self.processContentWithBlock()
        }
    }
    
    private func processContent() {
        if let content = getContent() {
            let shouldUpdate = shouldUpdateContent(content)
            if shouldUpdate.shouldUpdate {
                self.updateContentIfChanged(content)
                
                // Mark update hash as content is now up to date
                self.updateHash = shouldUpdate.hash
                self.contentDidUpdateWithHash(shouldUpdate.hash)
            }
        }
    }
    
    private func processContentWithBlock() {
        processConentQueue.addOperationWithBlock {
            self.processContent()
        }
    }
}


