//
//  PushCameraViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class PushCameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: CameraImageView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var lockStatusLabel: UILabel!
    private var lock: Lock?
    private var wasUnlockedFromCamera = false

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unlockButton(_ sender: Any) {
        wasUnlockedFromCamera = true
        lock?.unlock()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lock = Session.shared.selectedHome?.lock
        cameraView.setupImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lock?.subscribe(observer: self) { [weak self] oldValue, newValue in
            self?.changeLockViews(to: newValue)
        }
        changeLockViews(to: (lock?.status)!)
        cameraView.startAnimating()
        wasUnlockedFromCamera = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        lock?.unsubscribe(observer: self)
        cameraView.stopAnimating()
    }
    
    private func dismissIfneeded() {
        if wasUnlockedFromCamera{
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
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
            lockButton.isEnabled = true
            lockButton.imageView?.image = #imageLiteral(resourceName: "unlock_Button")
        case .unlocked:
            statusLabel = "Unlocked"
            lockStatusLabel.textColor = UIColor(red: 255/255, green: 149/255, blue: 0, alpha: 1)
            dismissIfneeded()
            disableLockButton()
        case .open:
            statusLabel = "Open"
            lockStatusLabel.textColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
            disableLockButton()
        }
        
        DispatchQueue.main.async {
            self.lockStatusLabel.text = statusLabel
        }
    }
    
    func disableLockButton(){
        lockButton.isEnabled = false
    }
    
}
