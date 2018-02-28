//
//  CameraViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 28/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: CameraImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.setupImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraView.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraView.stopAnimating()
    }
}
