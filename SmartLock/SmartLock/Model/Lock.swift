//
//  Lock.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

class Lock: Observable {
    typealias T = LockStatus
    
    let id: String
    private(set) var lockStatus: LockStatus {
        didSet {
            update(observers: observers, oldValue: oldValue, newValue: lockStatus)
        }
    }
    
    init(id: String) {
        self.id = id
        self.lockStatus = .locked
    }
    
    // MARK: Observable protocol
    var observers: [(AnyObject, UpdateBlock)] = []
    
    func subscribe(observer: AnyObject, updateBlock: @escaping UpdateBlock) {
        observers.append((observer, updateBlock))
    }
    
    func unsubscribe(observer: AnyObject) {
        observers = observers.filter { entry in
            let (owner, _) = entry
            return observer !== owner
        }
    }
}

extension Lock: LockCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: LockCommunicator) {
        // Figure out what to do here
        // Maybe request lock status?
    }
    
    func communicator(_ communicator: LockCommunicator, didReceive lockMessage: LockMessage) {
        switch lockMessage {
        case .didAutoLock: fallthrough
        case .didLock:
            lockStatus = .locked
        case .didUnlock: fallthrough
        case .didProximityUnlock:
            lockStatus = .unlocked
        case .didBuzz:
            NotificationManager.shared.sendBuzzNotification(from: self)
        }
    }
    
    func communicator(_ communicator: LockCommunicator, didReadRSSI RSSI: NSNumber) {
        if RSSI.floatValue > -59 {
            communicator.send(command: .proximityUnlock)
        }
    }
    
    func communicator(_ communicator: LockCommunicator, didWrite data: Data) {
        // Do nothing
    }
    
}
