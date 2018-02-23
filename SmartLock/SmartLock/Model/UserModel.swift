//
//  HomeModel.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 22/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class UserModel {
    static let shared = UserModel()
    
    var user: User?
    var selectedHome: Home?
    
    private init() {}
}
