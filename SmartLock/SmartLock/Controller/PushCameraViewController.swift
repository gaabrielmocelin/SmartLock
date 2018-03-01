//
//  PushCameraViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class PushCameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var lockStatusLabel: UILabel!
    private var lock: Lock?{
        return Session.shared.selectedHome?.lock
    }
    
    //this tuple means if we can dismiss automatically this vc
    //the .0 is for know if this lock button is who unlocked the door
    //the .1 is for know if the door was opened after the door being unlocked from the lock button
     private var wasUnlockedByTheCamera: (Bool, Bool) = (false,false)

    // MARK: buttons actions
    @IBAction func touchDownLockButton(_ sender: Any) {
        //scale animation begin
        UIButton.animate(withDuration: 0.2) {
            self.lockButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    //dismiss view controller
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unlockButton(_ sender: Any) {
        //scale animation finished
        UIButton.animate(withDuration: 0.2) {
            self.lockButton.transform = CGAffineTransform.identity
        }
        
        if let lock = lock{
            if lock.status == .locked{
                wasUnlockedByTheCamera.0 = true
                lock.unlock()
            }else if lock.status == .unlocked{
                lock.lock()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lockButton.layer.cornerRadius = lockButton.frame.size.height / 2
        lockButton.layer.masksToBounds = true
        
        //load fake images to simulate the videofeed
        cameraView.setupMockAnimation2()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //subscribe on lock
        lock?.subscribe(observer: self) { [weak self] oldValue, newValue in
            self?.changeLockViews(to: newValue)
        }
        //force update
        changeLockViews(to: (lock?.status)!)
        
        cameraView.startAnimating()
        
        //reset flags
        wasUnlockedByTheCamera = (false, false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        lock?.unsubscribe(observer: self)
        cameraView.stopAnimating()
    }
    
    private func automaticDismissVCIfNeeded() {
        if wasUnlockedByTheCamera.0, wasUnlockedByTheCamera.1{
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    private func changeLockViews(to status: LockStatus){
        var statusLabel = ""
        switch status {
        case .locked:
            statusLabel = "Locked"
            lockStatusLabel.textColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            enableLockButton(withTitle: "UNLOCK", color: UIColor(red: 0, green: 113/255, blue: 255/255, alpha: 1))
            automaticDismissVCIfNeeded()
        case .unlocked:
            statusLabel = "Unlocked"
            lockStatusLabel.textColor = UIColor(red: 255/255, green: 149/255, blue: 0, alpha: 1)
            enableLockButton(withTitle: "LOCK", color: UIColor(red: 0, green: 113/255, blue: 255/255, alpha: 1))
        case .open:
            wasUnlockedByTheCamera = wasUnlockedByTheCamera.0 ? (true,true) : (true,false)
            statusLabel = "Open"
            lockStatusLabel.textColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
            disableLockButton()
        }
        
        DispatchQueue.main.async {
            self.lockStatusLabel.text = statusLabel
        }
    }
    
    func enableLockButton(withTitle title: String, color: UIColor) {
        lockButton.isEnabled = true
        lockButton.setTitle(title, for: UIControlState.normal)
        lockButton.changeBackGroundColor(to: color, withDuration: 0.5)
    }
    
    func disableLockButton(){
        lockButton.isEnabled = false
        lockButton.changeBackGroundColor(to: UIColor.lightGray, withDuration: 0.5)
    }
    
}
