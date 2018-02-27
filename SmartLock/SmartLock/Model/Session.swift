//
//  Session.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 22/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class Session {
    static let shared = Session()
    
    var user: User?
    var selectedHome: Home?
    
    private init() {}
}
