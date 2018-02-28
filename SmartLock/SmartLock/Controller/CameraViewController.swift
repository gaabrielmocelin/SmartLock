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
    
    var lock: Lock{
        return (Session.shared.selectedHome?.lock)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.setupImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraView.startAnimating()
        navigationItem.title = "\(lock.name)'s Videofeed"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraView.stopAnimating()
    }
}
