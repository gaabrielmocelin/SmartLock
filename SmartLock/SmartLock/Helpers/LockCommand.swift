//
//  LockCommand.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 06/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

enum LockCommand: String, DataConvertible {
    var data: Data { return self.rawValue.data }
    
    case unlock = "U"
    case lock = "L"
    case proximityUnlock = "P"
    case receivedBuzzerAlert = "B"
    case status = "S"
}
