//
//  Lock.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation
import WatchConnectivity

class Lock: Observable {
    typealias T = LockStatus
    
    let name: String
    var lockCommunicator: LockCommunicator!
    fileprivate(set) var status: LockStatus {
        didSet {
            if oldValue != status {
                updateEntranceHistory()
            }
            update(observers: observers, oldValue: oldValue, newValue: status)
            updateWatchStatus()
        }
    }
    fileprivate(set) var entranceHistory: [EntranceItem]
    
    init(name: String, isWireless: Bool = true) {
        self.name = name
        self.status = .locked
        self.entranceHistory = []
        
        if isWireless {
            self.lockCommunicator = LockCommunicator(delegate: self)
            defer {
                lockCommunicator.send(command: .status)
            }
        }
    }
    
    func unlock() {
        lockCommunicator.send(command: .unlock)
    }
    
    func lock() {
        lockCommunicator.send(command: .lock)
    }
    
    // MARK: Watch
    
    func updateWatchStatus() {
        WCSession.default.sendMessage(["lockName" : name, "lockStatus" : status.rawValue], replyHandler: nil, errorHandler: nil)
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
    
    // MARK: Entrance History
    fileprivate func updateEntranceHistory() {
        if let user = Session.shared.user {
            let userName = user.nickname
            let entranceItem = EntranceItem(name: userName, lockStatus: status)
            self.entranceHistory.append(entranceItem)
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
            status = .locked
        case .didUnlock: fallthrough
        case .didProximityUnlock:
            status = .unlocked
        case .didBuzz:
            NotificationManager.shared.sendBuzzNotification(from: self)
        case .didOpen:
            status = .open
        }
    }
    
    func communicator(_ communicator: LockCommunicator, didReadRSSI RSSI: NSNumber) {
        print(RSSI)
        if RSSI.floatValue > -62 {
            communicator.send(command: .proximityUnlock)
        }
    }
    
    func communicator(_ communicator: LockCommunicator, didWrite data: Data) {
        // Do nothing
    }
}

class MockLock: Lock {
    
    override init(name: String, isWireless: Bool = true) {
        super.init(name: name, isWireless: false)
    }
    
    override func unlock() {
        status = .unlocked
    }
    
    override func lock() {
        status = .locked
    }
}
