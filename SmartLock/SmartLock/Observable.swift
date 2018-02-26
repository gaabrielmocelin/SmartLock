//
//  Observable.swift
//  SmartLock
//
//  Created by Max Zorzetti on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

protocol Observable {
    associatedtype T
    
    typealias UpdateBlock = (T, T) -> Void
    func subscribe(observer: AnyObject, updateBlock: @escaping UpdateBlock)
    func unsubscribe(observer: AnyObject)
    func update(observers: [(AnyObject, UpdateBlock)], oldValue: T, newValue: T)
}
extension Observable {
    func update(observers: [(AnyObject, UpdateBlock)], oldValue: T, newValue: T) {
        observers.forEach {
            $0.1(oldValue, newValue)
            print(#function)
            print($0.0)
        }
    }
}
