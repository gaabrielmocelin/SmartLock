//
//  DataConvertible.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 06/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import Foundation

protocol DataConvertible {
    var data: Data { get }
}

extension Data: DataConvertible {
    var data: Data { return self }
}
extension String : DataConvertible {
    var data: Data { return self.data(using: .utf8) ?? Data() }
}

extension UInt8: DataConvertible {
    var data: Data { return Data.init(bytes: [self]) }
}
