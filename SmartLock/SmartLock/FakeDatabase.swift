//
//  FakeDatabase.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 22/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class FakeDatabase {
    var users: [String : User]
    
    init() {
        let user = User(login: "", nickname: "João", password: "")
        let lock = Lock(id: "1")
        let home = Home(id: "1", name: "Home", members: [user], lock: lock)
        user.homes = [home]
        
        self.users = [user.login : user]
        
        let user2 = User(login: "", nickname: "Maria", password: "")
        let user3 = User(login: "", nickname: "Pedro", password: "")
        let members = [user, user2, user3]
        home.members = members
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
