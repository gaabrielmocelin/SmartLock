//
//  LockStatus.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

enum LockStatus {
    
    var formattedOutput: String {
        switch self {
        case .locked:
            return "Door Locked"
        case .unlocked:
            return "Door Unlocked"
        }
    }
    
    case locked
    case unlocked
}
