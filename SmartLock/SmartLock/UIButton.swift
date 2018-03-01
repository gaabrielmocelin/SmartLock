//
//  UIButton.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 28/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

extension UIButton{
    func changeBackGroundColor(to color: UIColor, withDuration duration: TimeInterval) {
        UIButton.animate(withDuration: duration) {
            self.backgroundColor = color
        }
    }
}
