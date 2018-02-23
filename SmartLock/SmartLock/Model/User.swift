//
//  User.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class User {
    let login: String
    var nickname: String
    var password: String
    var homes: [Home]
    
    init(login: String, nickname: String, password: String, homes: [Home] = []) {
        self.login = login
        self.nickname = nickname
        self.password = password
        self.homes = homes
    }
}
