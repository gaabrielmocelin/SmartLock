//
//  Guest.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 01/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class Guest {
    var name: String
    let phone: String
    let startingDate: Date
    var endingDate: Date
    
    init(name: String, phone: String, startingDate: Date, endingDate: Date) {
        self.name = name
        self.phone = phone
        self.startingDate = startingDate
        self.endingDate = endingDate
    }
}
