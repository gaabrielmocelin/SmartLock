//
//  CameraViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    var lock: Lock?

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unlockButton(_ sender: Any) {
        lock?.unlock()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lock = UserModel.shared.selectedHome?.lock
    }
}
