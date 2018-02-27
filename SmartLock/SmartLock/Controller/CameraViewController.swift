//
//  CameraViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var lockStatusLabel: UILabel!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lock?.subscribe(observer: self) { [weak self] oldValue, newValue in
            self?.changeLockViews(to: newValue)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        lock?.unsubscribe(observer: self)
    }
    
    private func changeLockViews(to status: LockStatus){
        switch status {
        case .locked:
            lockStatusLabel.text = "Locked"
            lockButton.imageView?.image = #imageLiteral(resourceName: "lock_button")
        case .unlocked:
            lockStatusLabel.text = "Unlocked"
            lockButton.imageView?.image = #imageLiteral(resourceName: "unlock_Button")
        }
    }
}
