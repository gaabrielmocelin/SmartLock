//
//  DoorInterfaceController.swift
//  SmartLockWatchOS Extension
//
//  Created by Matheus Vaccaro on 05/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DoorInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("AWAKE DOOR")
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
   
    @IBAction func didPressButton() {
        let session = WCSession.default
        let command = LockCommand.unlock.rawValue
        let message = [WatchLockMessageKey.name : "Front Door", WatchLockMessageKey.command : command]
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        session.sendMessageData(data, replyHandler: nil, errorHandler: nil)
    }
    
}
