//
//  UIImageView.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 28/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setupAnimation(forLiteralNames names: [String], withDuration duration: TimeInterval) {
        var images: [UIImage] = []
        for name in names{
            if let image = UIImage(named: name){
                images.append(image)
            }
        }
        self.animationImages = images
        self.animationDuration = duration
    }
    
    func setupMockAnimation() {
        var names: [String] = []
        for index in 1..<14{
            names.append("Frame_\(index)")
        }
        
        setupAnimation(forLiteralNames: names, withDuration: 1.3)
    }
    
    func setupMockAnimation2() {
        var names: [String] = []
        let totalFrames = 50
        for index in 0 ... totalFrames {
            names.append("frame_\(index)_delay-0.04s")
        }
        
        setupAnimation(forLiteralNames: names, withDuration: 50 * 0.04)
    }

}
