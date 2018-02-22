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
    func communicator(_ communicator: DoorLockCommunicator, didRead data: Data) {
        print(#function)
        print(String(data: data, encoding: .ascii)!)
    }
    func communicator(_ communicator: DoorLockCommunicator, didWrite data: Data) {
        print(#function)
        print(String(data: data, encoding: .ascii)!)
    }
}

