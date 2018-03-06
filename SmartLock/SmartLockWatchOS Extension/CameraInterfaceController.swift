//
//  CameraInterfaceController.swift
//  SmartLockWatchOS Extension
//
//  Created by Matheus Vaccaro on 06/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import WatchKit
import Foundation

class CameraInterfaceController: WKInterfaceController {

    @IBAction func didPressButton() {
        
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("AWAKE CAMERA")
    }
}
