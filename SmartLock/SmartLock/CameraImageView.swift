//
//  CameraImageView.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 28/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class CameraImageView: UIImageView {

    func setupImages(){
            var images: [UIImage] = []
            for index in 1..<14{
                images.append(UIImage(named: "Frame_\(index)")!)
                print("Frame_\(index)")
            }
            self.animationImages = images
            self.animationDuration = 1.3
    }

}
