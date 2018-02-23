//
//  Home.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class Home {
    let id: String
    var name: String
    var members: [User]
    var entranceHistory: [EntranceItem]
    let lock: Lock
    
    init(id: String, name: String, members: [User], lock: Lock, entranceHistory: [EntranceItem] = []) {
        self.id = id
        self.name = name
        self.lock = lock
        self.members = members
        self.entranceHistory = entranceHistory
    }
}
