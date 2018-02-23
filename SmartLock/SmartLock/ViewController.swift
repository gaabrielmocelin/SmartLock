//
//  ViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 21/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var doorLockCommunicator: DoorLockCommunicator!
    
    private var flag = true

    @IBAction func lockAction(_ sender: Any) {
        doorLockCommunicator.send(value: "L")
    }
    
    @IBAction func unlockAction(_ sender: Any) {
        doorLockCommunicator.send(value: "U")
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.doorLockCommunicator = DoorLockCommunicator(delegate: self)
    }


}

extension ViewController: DoorLockCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: DoorLockCommunicator) {
//        self.loadingComponent.removeLoadingIndicators(from: self.view)
    }
    
    @objc func resetFlag() {
        flag = true
    }
    
    func communicator(_ communicator: DoorLockCommunicator, didRead data: Data) {
        print(#function)
        let message = String(data: data, encoding: .utf8)!
        print(String(data: data, encoding: .utf8)!)
        
        if message == "B", flag{
            flag = false
            communicator.send(value: "B")
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: (#selector(resetFlag)), userInfo: nil, repeats: true)
        }
        
    }
    
    func communicator(_ communicator: DoorLockCommunicator, didWrite data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8)!)
    }
    
    func communicator(_ communicator: DoorLockCommunicator, didReadRSSI RSSI: NSNumber) {
        if RSSI.floatValue > -59 {
            doorLockCommunicator.send(value: "U")
        }
    }
}

