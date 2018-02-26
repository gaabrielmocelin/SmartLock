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
    private var lock: Lock! // GET REAL LOCK
    @IBOutlet weak var lockStatusImageView: UIImageView!
    
    @IBAction func lockAction(_ sender: Any) {
        lock.lock()
        UserModel.shared.selectedHome!.updateEntranceHistoryWith(user: user, andLockStatus: .locked)
    }
    
    @IBAction func unlockAction(_ sender: Any) {
        lock.unlock()
        UserModel.shared.selectedHome!.updateEntranceHistoryWith(user: user, andLockStatus: .unlocked)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lock.subscribe(observer: self) { [weak self] oldValue, newValue in
            self?.changeLockImageView(to: newValue)
        }
        changeLockImageView(to: lock.status)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lock = Lock(id: "Dandy") // GET REAL LOCK
        self.user = UserModel.shared.user
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        lock.unsubscribe(observer: self)
    }
    
    private func changeLockImageView(to status: LockStatus) {
        switch status {
        case .locked:
            lockStatusImageView.image = #imageLiteral(resourceName: "locked_icon")
        case .unlocked:
            lockStatusImageView.image = #imageLiteral(resourceName: "unlocked_icon")
        }
    }
}

