//
//  LockMessage.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 06/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

enum LockMessage: String, DataConvertible {
    var data: Data { return self.rawValue.data }
    
    case didUnlock = "U"
    case didLock = "L"
    case didProximityUnlock = "P"
    case didAutoLock = "A"
    case didBuzz = "B"
    case didOpen = "O"
}

