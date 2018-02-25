//
//  RemoteLockViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 21/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class RemoteLockViewController: UIViewController {
    
    private var lockCommunicator: LockCommunicator!

    @IBAction func lockAction(_ sender: Any) {
        lockCommunicator.send(command: .lock)
    }
    
    @IBAction func unlockAction(_ sender: Any) {
        lockCommunicator.send(command: .unlock)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.lockCommunicator = LockCommunicator(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lockCommunicator = LockCommunicator(delegate: self)
    }
    
}

extension RemoteLockViewController: LockCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: LockCommunicator) {
//        self.loadingComponent.removeLoadingIndicators(from: self.view)
    }
    
    func communicator(_ communicator: LockCommunicator, didRead data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8)!)
    }
    
    func communicator(_ communicator: LockCommunicator, didWrite data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8)!)
    }
    
    func communicator(_ communicator: LockCommunicator, didReadRSSI RSSI: NSNumber) {
        if RSSI.floatValue > -59 {
            lockCommunicator.send(command: .proximityUnlock)
        }
    }
}

