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

    private var lockStatus: LockStatus! {
        didSet {
            didUpdate(lockStatus: lockStatus)
        }
    }
    
    private var isDisplayingCamera: Bool = false {
        didSet {
            lockStatusIcon.setHidden(isDisplayingCamera)
            camera.setHidden(!isDisplayingCamera)
            cameraButton.setTitle(isDisplayingCamera ? "Status" : "Camera")
            updateImage(with: lockStatus)
        }
    }
    
    @IBOutlet var lockButton: WKInterfaceButton!
    @IBOutlet var cameraButton: WKInterfaceButton!
    
    @IBOutlet var lockStatusIcon: WKInterfaceImage!
    @IBOutlet var camera: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("AWAKE DOOR")
        lockStatus = LockStatus.locked
        isDisplayingCamera = false
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
   
    @IBAction func didPressLockButton() {
        let session = WCSession.default
        if session.isReachable {
            let command: LockCommand
            switch lockStatus {
            case .locked:
                command = LockCommand.unlock
                lockStatus = .unlocked
            case .unlocked:
                command = LockCommand.lock
                lockStatus = .locked
            default:
                return
            }
            let message = [WatchLockMessageKey.name.rawValue : "Front Door", WatchLockMessageKey.command.rawValue : command.rawValue]
            let data = NSKeyedArchiver.archivedData(withRootObject: message)
            session.sendMessageData(data, replyHandler: nil, errorHandler: nil)
        }
    }
    
    @IBAction func didPressCameraButton() {
        isDisplayingCamera = !isDisplayingCamera
    }
    
    private func didUpdate(lockStatus: LockStatus) {
        switch lockStatus {
        case .locked:
            self.lockButton.setTitle("Unlock")
            self.lockButton.setEnabled(true)
            self.lockButton.setBackgroundImage(UIImage(named:"blueBg"))
            self.lockButton.setBackgroundColor(nil)
            if !isDisplayingCamera {
                updateImage(with: lockStatus)
            }
        case .unlocked:
            self.lockButton.setTitle("Lock")
            self.lockButton.setEnabled(true)
            self.lockButton.setBackgroundImage(UIImage(named:"blueBg"))
            self.lockButton.setBackgroundColor(nil)
            if !isDisplayingCamera {
                updateImage(with: lockStatus)
            }
        case .open:
            self.lockButton.setTitle("...")
            self.lockButton.setEnabled(false)
            self.lockButton.setBackgroundImage(nil)
            self.lockButton.setBackgroundColor(.gray)
            if !isDisplayingCamera {
                updateImage(with: lockStatus)
            }
        }
    }
    
    private func updateImage(with lockStatus: LockStatus) {
        switch lockStatus {
        case .locked:
            self.lockStatusIcon.setImage(UIImage(named: "IconLocked"))
        case .unlocked:
            self.lockStatusIcon.setImage(UIImage(named: "IconUnlocked"))
        case .open:
            self.lockStatusIcon.setImage(UIImage(named: "IconOpen"))
        }
    }
}
