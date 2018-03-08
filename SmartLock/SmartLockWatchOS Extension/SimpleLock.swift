//
//  SimpleLock.swift
//  SmartLockWatchOS Extension
//
//  Created by Matheus Vaccaro on 08/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class SimpleLock: Observable {
    typealias T = LockStatus
    
    var name: String
    var status: LockStatus {
        didSet {
            update(observers: observers, oldValue: oldValue, newValue: status)
        }
    }
    var isSelected: Bool
    
    init() {
        self.name = "Error"
        self.status = .locked
        self.isSelected = false
    }
    
    // MARK: Observable Protocol
    
    var observers: [(AnyObject, UpdateBlock)] = []
    
    func subscribe(observer: AnyObject, updateBlock: @escaping (LockStatus, LockStatus) -> Void) {
        observers.append((observer, updateBlock))
    }
    
    func unsubscribe(observer: AnyObject) {
        observers = observers.filter { entry in
            let (owner, _) = entry
            return observer !== owner
        }
    }
}

class Locks {
    
    static let shared = Locks()
    
    var locks: [SimpleLock] = []
    
    private init() { }
    
    func reset() {
        locks.forEach{ $0.observers = [] }
        locks = []
    }
}
