//
//  ArduinoCommunicator.swift
//  BluetoothTest
//
//  Created by Nicolas Nascimento on 18/12/17.
//  Copyright © 2017 Nicolas Nascimento. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol LockCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: LockCommunicator)
    func communicator(_ communicator: LockCommunicator, didReceive lockMessage: LockMessage)
    func communicator(_ communicator: LockCommunicator, didWrite data: Data)
    func communicator(_ communicator: LockCommunicator, didReadRSSI RSSI: NSNumber)
}

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

/// This class abstracts communication with the Arduino Bluetooth Module.
/// It has methods for reading and writing data to Arduino.
class LockCommunicator: NSObject {
    
    /// Set this to handle callbacks
    var delegate: LockCommunicatorDelegate?
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral? {
        didSet {
            if let peripheral = peripheral {
                rssiTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    peripheral.readRSSI()
                }
            } else {
                rssiTimer?.invalidate()
            }
        }
    }
    private var characterist: CBCharacteristic?
    
    private var rssiTimer: Timer?
    
    private let expectedPeripheralName = "FLEXLOCK"
    private let expectedCharacteristicUUIDString = "DFB1"
    private(set) var isReady: Bool = false
    
    private let notificationManager = NotificationManager()
    
    //FIX IT: THIS FLAG SHOULD BE ANOTHER THING ******************
    private var shouldFireNotification = true
    
    // MARK: - Private Methods
    init(delegate: LockCommunicatorDelegate? = nil) {
        super.init()
        
        // Set delegate
        self.delegate = delegate
        
        // Begin looking for elements
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    public func send(command: LockCommand) {
        send(value: command)
    }
    
    // MARK: - Private
    
    /// Sends the bytes provided to Arduino using Bluetooth
    private func send<T: DataConvertible>(value: T) {
        if( self.isReady ) {
            guard let characterist = self.characterist else { return }
            self.peripheral?.writeValue(value.data, for: characterist, type: .withoutResponse)
        }
    }
    /// Read data from Arduino Module, if possible
    private func read() {
        if( self.isReady ) {
            guard let characterist = self.characterist else { return }
            self.peripheral?.readValue(for: characterist)
        }
    }
}

extension LockCommunicator: CBCentralManagerDelegate {
    
    // Called once the manager has beed updated
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            print(" Powered On - Began Scanning...")
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff:
            print("WARNING Powered Off - Bluetooth is Disabled. Switch it on and try again")
        default:
            print("WARNING: - state not supported \(String.init(describing: central.state))")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // We should only try to connect to the peripheral we're interested in
        // In this case, we can use its name
        if( peripheral.name == self.expectedPeripheralName ) {
            print("Discovered \(self.expectedPeripheralName)")
            self.peripheral = peripheral
            
            print("Attemping Connection to \(self.expectedPeripheralName)")
            // Attemp connection
            central.connect(peripheral, options: nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        // Allow delegate to update status
        self.delegate?.communicatorDidConnect(self)
        
        // Once connection is stabilished, we can begin discovering services
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

extension LockCommunicator: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characterist in service.characteristics ?? []  {
            if( characterist.uuid.uuidString == self.expectedCharacteristicUUIDString ) {
                print("Discovered Characteristic \(characterist), for Service \(service)")
                self.characterist = characterist
                self.isReady = true
                peripheral.setNotifyValue(true, for: characterist)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let characteristOfInterest = self.characterist, let data = characteristOfInterest.value  else { return }
        if characteristic.uuid.uuidString == characteristOfInterest.uuid.uuidString {
            guard let message = String(data: data, encoding: .utf8) else { return }
            print("MESSAGE: \(message)")
            if let lockMessage = LockMessage(rawValue: message) {
                delegate?.communicator(self, didReceive: lockMessage)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let characteristOfInterest = self.characterist, let data = characteristOfInterest.value else { return }
        if( characteristic.uuid.uuidString == characteristOfInterest.uuid.uuidString ) {
            
            // Allows the delegate to handle data exchange (write)
            self.delegate?.communicator(self, didWrite: data)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        delegate?.communicator(self, didReadRSSI: RSSI)
    }
}
enum LockMessage: String, DataConvertible {
    var data: Data { return self.rawValue.data }
    
    case didUnlock = "U"
    case didLock = "L"
    case didProximityUnlock = "P"
    case didAutoLock = "A"
    case didBuzz = "B"
    case didOpen = "O"
}

enum LockCommand: String, DataConvertible {
    var data: Data { return self.rawValue.data }
    
    case unlock = "U"
    case lock = "L"
    case proximityUnlock = "P"
    case receivedBuzzerAlert = "B"
    case status = "S"
}
