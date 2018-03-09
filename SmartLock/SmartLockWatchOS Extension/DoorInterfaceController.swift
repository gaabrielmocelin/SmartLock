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

    private var lock: SimpleLock?
    
    private var isDisplayingCamera: Bool = false {
        didSet {
            lockStatusIcon.setHidden(isDisplayingCamera)
            camera.setHidden(!isDisplayingCamera)
            cameraButton.setTitle(isDisplayingCamera ? "Status" : "Camera")
            
            guard let lock = self.lock else { return }
            updateImage(with: lock.status)
        }
    }
    
    @IBOutlet var lockButton: WKInterfaceButton!
    @IBOutlet var cameraButton: WKInterfaceButton!
    
    @IBOutlet var lockStatusIcon: WKInterfaceImage!
    @IBOutlet var camera: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("AWAKE DOOR")
        
        isDisplayingCamera = false
        
        if let context = context as? SimpleLock {
            self.lock = context
            
            self.setTitle(context.name)
            if context.isSelected {
                becomeCurrentPage()
            }
            
        } else {
            isDisplayingCamera = true
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        guard let lock = self.lock else { return }
        
        lock.subscribe(observer: self) { [weak self] oldValue, newValue in
            self?.didUpdate(lockStatus: newValue)
        }
        
        didUpdate(lockStatus: lock.status)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        guard let lock = self.lock else { return }
        
        lock.unsubscribe(observer: self)
    }
   
    @IBAction func didPressLockButton() {
        print(#function)
        guard let lock = self.lock else { return }
        
        let session = WCSession.default
        if session.isReachable {
            let command: LockCommand
            switch lock.status {
            case .locked:
                command = LockCommand.unlock
            case .unlocked:
                command = LockCommand.lock
            default:
                return
            }
            let message = [WatchLockMessageKey.name.rawValue : lock.name, WatchLockMessageKey.command.rawValue : command.rawValue]
            let data = NSKeyedArchiver.archivedData(withRootObject: message)
            session.sendMessageData(data, replyHandler: { (msg) in
                print(msg)
            }, errorHandler: { (error) in
                print(error)
            })
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
