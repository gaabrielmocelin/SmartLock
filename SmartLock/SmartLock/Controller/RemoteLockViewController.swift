//
//  RemoteLockViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 21/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class RemoteLockViewController: UIViewController {
    
    private var user: User!
    private var lock: Lock!
    
    @IBOutlet weak var lockStatusImageView: UIImageView!
    @IBOutlet weak var lockStatusLabel: UILabel!
    
    @IBAction func lockAction(_ sender: Any) {
        lock.lock()
        UserModel.shared.selectedHome!.updateEntranceHistoryWith(user: user, andLockStatus: .locked)
    }
    
    @IBAction func unlockAction(_ sender: Any) {
        lock.unlock()
        UserModel.shared.selectedHome!.updateEntranceHistoryWith(user: user, andLockStatus: .unlocked)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lock = UserModel.shared.selectedHome!.lock
        self.user = UserModel.shared.user
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lock.subscribe(observer: self) { [weak self] oldValue, newValue in
            self?.updateLockStatusImageView(to: newValue)
            self?.updateLockStatusLabel(to: newValue)
        }
        updateLockStatusImageView(to: lock.status)
        updateLockStatusLabel(to: lock.status)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        lock.unsubscribe(observer: self)
    }
    
    private func updateLockStatusImageView(to status: LockStatus) {
        switch status {
        case .locked:
            lockStatusImageView.image = #imageLiteral(resourceName: "locked_icon")
        case .unlocked:
            lockStatusImageView.image = #imageLiteral(resourceName: "unlocked_icon")
        }
    }
    
    private func updateLockStatusLabel(to status: LockStatus) {
        switch status {
        case .locked:
            lockStatusLabel.text = "Locked"
            lockStatusLabel.textColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        case .unlocked:
            lockStatusLabel.text = "Unlocked"
            lockStatusLabel.textColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
        }
    }
}

