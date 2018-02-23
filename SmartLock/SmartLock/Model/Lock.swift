//
//  Lock.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class Lock {
    let id: String
    var isLocked: Bool
    
    init(id: String) {
        self.id = id
        self.isLocked = true
    }
}
