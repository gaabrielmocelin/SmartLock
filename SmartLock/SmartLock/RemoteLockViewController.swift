//
//  RemoteLockViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 21/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class RemoteLockViewController: UIViewController {
    
    private var doorLockCommunicator: DoorLockCommunicator!

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

extension RemoteLockViewController: DoorLockCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: DoorLockCommunicator) {
//        self.loadingComponent.removeLoadingIndicators(from: self.view)
    }
    
    func communicator(_ communicator: DoorLockCommunicator, didRead data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8)!)
    }
    
    func communicator(_ communicator: DoorLockCommunicator, didWrite data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8)!)
    }
}

