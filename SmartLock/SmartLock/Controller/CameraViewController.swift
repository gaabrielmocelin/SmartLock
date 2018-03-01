//
//  CameraViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 28/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIImageView!
    
    var lock: Lock{
        return (Session.shared.selectedHome?.lock)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.setupMockAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraView.startAnimating()
        navigationItem.title = "\(lock.name)'s Videofeed"
    }
    
    
    //IT SHOULD BE DELETED LATER, ITS TO TEXT THE PUSH CAMERA VC
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        let fakeDatabase = FakeDatabase()
//        if let user = Session.shared.user{
//            let u = fakeDatabase.users[user.login]
//            Session.shared.selectedHome = u!.homes[1]
//            NotificationManager.shared.sendBuzzNotification(from: Session.shared.selectedHome!.lock)
//        }
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraView.stopAnimating()
    }
}
