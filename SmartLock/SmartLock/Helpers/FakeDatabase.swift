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
        let user = User(login: "", nickname: "João", password: "", phone: "999999999")
        let lock = Lock(name: "Front Door")
        let home = Home(id: "1", name: "Home", members: [user], lock: lock)
        let mockHome = Home(id: "2", name: "Beach House", members: [user], lock: MockLock(name: "Beach Door"))
        user.homes = [home, mockHome]
        
        self.users = [user.login : user]
        
        let user2 = User(login: "", nickname: "Maria", password: "", phone: "999999999")
        let user3 = User(login: "", nickname: "Pedro", password: "", phone: "999999999")
        let members = [user, user2, user3]
        home.members = members
        
//        let guest1 = Guest(name: "Marco", phone: "999999999", startingDate: Date(), endingDate: Date().addingTimeInterval(7200))
//        home.guests = [guest1]
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
