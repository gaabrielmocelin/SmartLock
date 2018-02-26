//
//  TabBarController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "CameraIcon")
        navigationItem.setRightBarButton(UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(openCamera)), animated: true)
    }
    
    @objc func openCamera() {
        
    }
}
