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
    @IBOutlet weak var lockButton: UIButton!
    
    @IBOutlet weak var closeDoorWarningLabel: UILabel!
    
    @IBAction func lockAction(_ sender: Any) {
        switch lock.status {
        case .locked:
            lock.unlock()
        case .unlocked:
            lock.lock()
        case .open:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lock = Session.shared.selectedHome!.lock
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLockStatusImageView(to: lock.status)
        updateLockStatusLabel(to: lock.status)
        updateLockButton(to: lock.status)
        
        lock.subscribe(observer: self) { [weak self] oldValue, newValue in
            self?.updateLockStatusImageView(to: newValue)
            self?.updateLockStatusLabel(to: newValue)
            self?.updateLockButton(to: newValue)
        }
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
        case .open:
            lockStatusImageView.image = #imageLiteral(resourceName: "open_icon")
        }
    }
    
    private func updateLockStatusLabel(to status: LockStatus) {
        switch status {
        case .locked:
            lockStatusLabel.text = "Locked"
            lockStatusLabel.textColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
            closeDoorWarningLabel.isHidden = true
        case .unlocked:
            lockStatusLabel.text = "Unlocked"
            lockStatusLabel.textColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
            closeDoorWarningLabel.isHidden = true
        case .open:
            lockStatusLabel.text = "Open"
            lockStatusLabel.textColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            closeDoorWarningLabel.isHidden = false
        }
    }
    
    private func updateLockButton(to status: LockStatus) {
        switch status{
        case .locked:
            lockButton.setImage(#imageLiteral(resourceName: "lock_button"), for: .normal)
        case .unlocked:
            lockButton.setImage(#imageLiteral(resourceName: "unlock_Button"), for: .normal)
        case .open:
            lockButton.setImage(#imageLiteral(resourceName: "open_button"), for: .normal)
        }
    }
}

