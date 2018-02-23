//
//  ViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 21/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var lockCommunicator: LockCommunicator!
    
    private var flag = true

    @IBAction func lockAction(_ sender: Any) {
        lockCommunicator.send(command: .lock)
    }
    
    @IBAction func unlockAction(_ sender: Any) {
        lockCommunicator.send(command: .unlock)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lockCommunicator = LockCommunicator(delegate: self)
    }


}

extension ViewController: LockCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: LockCommunicator) {
//        self.loadingComponent.removeLoadingIndicators(from: self.view)
    }
    
    @objc func resetFlag() {
        flag = true
    }
    
    func communicator(_ communicator: LockCommunicator, didRead data: Data) {
        print(#function)
        let message = String(data: data, encoding: .utf8)!
        print(String(data: data, encoding: .utf8)!)
        
        if message == "B", flag{
            flag = false
            communicator.send(command: .receivedBuzzerAlert)
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: (#selector(resetFlag)), userInfo: nil, repeats: true)
        }
        
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

