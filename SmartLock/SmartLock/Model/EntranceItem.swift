//
//  EntranceItem.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class EntranceItem {

    let name: String
    let lockStatus: LockStatus
    let timeStamp: Date
    
    init(name: String, lockStatus: LockStatus, timeStamp: Date = Date()) {
        self.name = name
        self.lockStatus = lockStatus
        self.timeStamp = timeStamp
    }
}

extension EntranceItem: Equatable {
    static func ==(lhs: EntranceItem, rhs: EntranceItem) -> Bool {
        return lhs.name == rhs.name && lhs.lockStatus == rhs.lockStatus && lhs.timeStamp == rhs.timeStamp
    }
}

extension EntranceItem: CustomStringConvertible {
    var description: String {
        return "Name: \(name), LockStatus: \(lockStatus), TimeStamp: \(timeStamp)\n"
    }
}
