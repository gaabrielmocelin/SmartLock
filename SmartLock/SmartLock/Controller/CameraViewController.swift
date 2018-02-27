//
//  CameraViewController.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var lockStatusLabel: UILabel!
    private var lock: Lock?
    private var wasUnlockedFromCamera = false

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unlockButton(_ sender: Any) {
        lock?.unlock()
        wasUnlockedFromCamera = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lock = UserModel.shared.selectedHome?.lock
        loadImages()
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
    
    private func changeLockViews(to status: LockStatus){
        var statusLabel = ""
        switch status {
        case .locked:
            statusLabel = "Locked"
            lockButton.imageView?.image = #imageLiteral(resourceName: "unlock_Button")
        case .unlocked:
            statusLabel = "Unlocked"
            if wasUnlockedFromCamera{
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
//            lockButton.imageView?.image = #imageLiteral(resourceName: "lock_button")
        }
        
        DispatchQueue.main.async {
            self.lockStatusLabel.text = statusLabel
        }
    }
    
    func loadImages() {
        var images: [UIImage] = []
        for index in 1..<14{
            images.append(UIImage(named: "Frame_\(index)")!)
            print("Frame_\(index)")
        }
        cameraView.animationImages = images
        cameraView.animationDuration = 1.3
    }
}
