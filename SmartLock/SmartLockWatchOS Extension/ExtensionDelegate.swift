//
//  ExtensionDelegate.swift
//  SmartLockWatchOS Extension
//
//  Created by Matheus Vaccaro on 05/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    var session: WCSession?
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        if (WCSession.isSupported()) {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        
//        let contexts: [(name: String, context: AnyObject)] = [("lockInterfaceController", ["lockName" : "Front Door" as AnyObject, "lockStatus" : "unlocked" as AnyObject, "isSelected" : true as AnyObject] as [String : AnyObject] as AnyObject), ("lockInterfaceController", ["lockName" : "Beach House" as AnyObject, "lockStatus" : "unlocked" as AnyObject, "isSelected" : false as AnyObject] as [String : AnyObject] as AnyObject)]
//
//        WKInterfaceController.reloadRootControllers(withNamesAndContexts: contexts)
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}

extension ExtensionDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let lockName = message["lockName"] as! String
        let status = LockStatus(rawValue: message["lockStatus"] as! String)!
        
        Locks.shared.locks.filter{ $0.name == lockName }.first!.status = status
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        let lockInfos = applicationContext["locks"] as! [[String : Any]]
        
        Locks.shared.reset()
        
        for lockInfo in lockInfos {
            let lockName = lockInfo["lockName"] as! String
            let lockStatus = LockStatus(rawValue: (lockInfo["lockStatus"] as! String))!
            let isSelected = lockInfo["isSelected"] as! Bool
            
            let simpleLock = SimpleLock()
            simpleLock.status = lockStatus
            simpleLock.name = lockName
            simpleLock.isSelected = isSelected
            
            Locks.shared.locks.append(simpleLock)
        }
        
        let contexts: [(String, AnyObject)] = Locks.shared.locks.map {
            return ("lockInterfaceController", $0 as AnyObject)
        }

        WKInterfaceController.reloadRootControllers(withNamesAndContexts: contexts)
    }
}
