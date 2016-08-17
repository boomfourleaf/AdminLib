//
//  flPrinterService.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/4/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class flPrinterService {
    public let printerName: String
    public var shouldStop = false

    private var taskQueueIdAndPrinter: [String: dispatch_queue_t]!
    private var queueRunNumber = 0
    private var finishedJobs: [String]!
    
    // Watch Dog
    private var watchDogMark = WATCHDOG_OK
    private var watchDogTimer: NSTimer?
    
    private lazy var _FinishedJobLock = NSObject()
    private var _TaskQueueIdAndPrinterQueue: dispatch_queue_t!
    
    private var myService: flServiceController!

    public init(printerName: String) {
        self.printerName = printerName
    }
    
    deinit {
        flLog.info("Printer Servcie \(printerName) dealloc")
    }
}

//MARK: Setup
extension flPrinterService {
    private func initServices() {
        _TaskQueueIdAndPrinterQueue = dispatch_queue_create("flPrinterServiceTaskQueueAndPrinterQueue_\(printerName)_\(queueRunNumber)", DISPATCH_QUEUE_SERIAL)
        
        taskQueueIdAndPrinter = [String: dispatch_queue_t]()
        myService = flServiceController()
        finishedJobs = [String]()
    }
}

//MARK: Finished Job
extension flPrinterService {
    private func markAsFinished(jobId: String)  {
        synced(_FinishedJobLock) {
            self.finishedJobs.append(jobId)
        }
    }

    private func clearAllFinsihedJobIds() {
        synced(_FinishedJobLock) {
            self.finishedJobs.removeAll()
        }
    }
    
    private func finishedJobsIdString() -> String {
        var output = "-"
        
        synced(_FinishedJobLock) {
            output = self.finishedJobs.joinWithSeparator(",")
            if output == "" {
                output = "-"
            }
        }
        return output
    }
}

//MARK: Concurrency Task Queues
extension flPrinterService {
    private func getQueueAndPrinter(identify: String, andModel model: String) -> (dispatch_queue_t, flPrinterProtocol) {
        var queue: dispatch_queue_t!
        dispatch_sync(_TaskQueueIdAndPrinterQueue) {
            let queueIdentify = "flPrinterServiceTaskQueue_\(model)_\(identify)_\(self.queueRunNumber)"
            if let cacheQueue = self.taskQueueIdAndPrinter[queueIdentify] {
                queue = cacheQueue

            } else {
                queue = dispatch_queue_create(queueIdentify, DISPATCH_QUEUE_SERIAL)
                self.taskQueueIdAndPrinter[queueIdentify] = queue
            }
        }
        
        let printer: flPrinterProtocol
        switch PRINTER_VENDOR(modelName: model) {
        case .STAR: printer = flPrinterStar()
        case .EPSON: printer = flPrinterEpson()
        }
        
        return (queue, printer)
    }
}

//MARK: Operation
extension flPrinterService {
    private func printCommands(commands: [JSON], printer: flPrinterProtocol) -> Bool {
        for command in commands {
            let result = printer.printCommand(command.dictionaryObjectValue)
            if result != .SUCCESS {
                ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"printCommand", detail:"\(command)")
                return false
            }
            
            
        }
        let result = printer.sendData()
        if result != .SUCCESS {
            ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"sendData", detail:"\(commands)")
            return false
        }
        
        return true
    }
    
    private func printJob(job: JSON, printer: flPrinterProtocol) -> Bool {
        let address = job["address"].stringValue
        let model = job["model"].stringValue
        let lineMaxChar = job["line_max_char"].intValue
        let lineWidth = job["line_width"].intValue
        let vendor = "EPSON"
        
        // Configure Printer
        printer.lineMaxChar = lineMaxChar
        printer.lineWidth = lineWidth
        printer.vendor = vendor
        printer.address = address
        printer.model = model
        
        // Open Printer
        var result = printer.openPrinter()
        if result != .SUCCESS {
            printer.closePrinter(false)
            
            ShowMsg.showError("Can't connect \(printerName) (\(address))\n" +
                "id: \(job["id"].stringValue)\n" +
                "name: \(printerName)\n" +
                "address: \(address)\n" +
                "model: \(model)\n" +
                "vendor: \(vendor) (run\(queueRunNumber))")
            return false
        }

        printer.newBuilder()
        
        let commandSuccess = printCommands(job["print"].arrayValue, printer:printer)
        if false == commandSuccess {
            printer.closePrinter()
            return false
        }
        
        // Close Printer
        result = printer.closePrinter()
        if result != .SUCCESS {
            ShowMsg.showExceptionEpos(Int32(result.rawValue), method:"closePrinter", detail:"address:\(address) model:\(model) lineMaxChar:\(lineMaxChar) lineWidth:\(lineWidth)")
            return false
        }
        return true
    }

    func printJobs(jobs: [JSON]) -> Bool {
        for job in jobs {
            let pritnerModel = job["model"].stringValue
            let (queue, printer) = getQueueAndPrinter(job["address"].stringValue, andModel: pritnerModel)

            var shouldBreak = false
            dispatch_sync(queue) {
                let printSuccess = self.printJob(job, printer:printer)
                if printSuccess {
                    self.markAsFinished(job["id"].stringValue)
                } else {
                    if self.isSlowConnection(job, model: pritnerModel) {
                        shouldBreak = true
                    }
                }
            }
            if shouldBreak {
                break
            }
        }
        
        return true
    }

    func fetchNewJobs() -> [JSON]? {
        guard let dataDict = myService.fetchPrinterNewJob(printerName, lastJob:finishedJobsIdString()) else { return nil }
        
        clearAllFinsihedJobIds()
        return (dataDict[API_ROOT_DATAS] as? [ObjcDictionary])?.map{ JSON($0) }
    }
}

//MARK: Run Loop
extension flPrinterService {
    public func runLoop() {
        // Init
        initServices()
        let thisRunningNumber = queueRunNumber
        
        var shouldBreakWhile = false
        while (true) {
            if shouldBreakWhile { return }
            autoreleasepool {
                if shouldStop {
                    flLog.info("Stop printer service \(printerName)")
                    shouldBreakWhile = true; return
                }

                // Stop if this queue is mark as dead (by Watchdog)
                if thisRunningNumber != queueRunNumber {
                    flLog.error("kill run loop \(thisRunningNumber)")
                    shouldBreakWhile = true; return
                }
                
                // Fetch new jobs and print
                if let jobs = fetchNewJobs() where jobs.count > 0 {
                    printJobs(jobs)
                    watchDogMark = WATCHDOG_OK
                    flLog.info("PRINTER_SERVICE_FETCH_INTERVAL \(printerName)(queue-id \(thisRunningNumber)) \(PRINTER_SERVICE_FETCH_INTERVAL)")
                    sleep( UInt32(PRINTER_SERVICE_FETCH_INTERVAL) )

                } else {
                    // Do nothing
                    flLog.info("PRINTER_SERVICE_FETCH_INTERVAL_IDLE_STATE \(printerName) \(PRINTER_SERVICE_FETCH_INTERVAL_IDLE_STATE) (run\(thisRunningNumber))")
                    sleep(UInt32(PRINTER_SERVICE_FETCH_INTERVAL_IDLE_STATE))
                }

                watchDogMark = WATCHDOG_OK
            }
        }
    }
}

//MARK: Watchdog
extension flPrinterService {
    public func startTimerForWatchDog() {
        watchDogMark = WATCHDOG_OK
        flLog.info("PRINTER_SERVICE_WATCHDOG_TIMEOUT \(PRINTER_SERVICE_WATCHDOG_TIMEOUT)")
        watchDogTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(PRINTER_SERVICE_WATCHDOG_TIMEOUT), target:self, selector:#selector(checkAlive(_:)), userInfo:nil, repeats:true)
    }
    
    public func stopTimerForWatchDog() {
        watchDogTimer?.invalidate()
        watchDogTimer = nil
    }
    
    dynamic func checkAlive(timer: NSTimer) {
        if WATCHDOG_DIRTY == watchDogMark {
            watchDogMark = WATCHDOG_OK
            flLog.info("new run loop \(queueRunNumber + 1)")
            queueRunNumber += 1
            // New Runloop
            background { self.runLoop() }

        } else {
            watchDogMark = WATCHDOG_DIRTY
        }
    }
}

//MARK: Vendor Checking
extension flPrinterService {
    private enum PRINTER_VENDOR {
        case EPSON, STAR
        
        init(modelName: String) {
            if nil != modelName.rangeOfString("STAR-") {
                self = .STAR
            } else {
                self = .EPSON
            }
        }
    }
}

//MARK: Star Helper
extension flPrinterService {
    // For Star TCP:xx and BLE:xx interface have slow conneciotn
    func isSlowConnection(job: JSON, model: String) -> Bool {
        let portName = job["address"].stringValue

        if portName.hasPrefix("TCP:") || portName.hasPrefix("BLE:") {
            return true
        } else {
            return false
        }
    }
}
