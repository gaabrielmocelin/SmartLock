//
//  HomeModel.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 22/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class HomeModel {
    
}

class UserModel {
    static let shared = UserModel()
    
    var users: [String : User]
    
    private init() {
        let user = User(login: "login", nickname: "John", password: "password")
        let lock = Lock(id: "1")
        let home = Home(id: "1", name: "Home", members: [user], lock: lock)
        user.homes = [home]
        
        self.users = [user.login : user]
    }
    
    func verify(login: String, password: String) -> User? {
        if let user = users[login] {
            if login == user.login && password == user.password {
                return user
            }
        }
        return nil
    }
}

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

class Home {
    let id: String
    var name: String
    var members: [User]
    var entranceHistory: [String]
    let lock: Lock
    
    init(id: String, name: String, members: [User], lock: Lock) {
        self.id = id
        self.name = name
        self.lock = lock
        self.members = members
        self.entranceHistory = [String]()
    }
    
}

class Lock {
    let id: String
    var isLocked: Bool
    
    init(id: String) {
        self.id = id
        self.isLocked = true
    }
}


