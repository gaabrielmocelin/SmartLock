//
//  ArduinoCommunicator.swift
//  BluetoothTest
//
//  Created by Nicolas Nascimento on 18/12/17.
//  Copyright © 2017 Nicolas Nascimento. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol DoorLockCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: DoorLockCommunicator)
    func communicator(_ communicator: DoorLockCommunicator, didRead data: Data)
    func communicator(_ communicator: DoorLockCommunicator, didWrite data: Data)
    func communicator(_ communicator: DoorLockCommunicator, didReadRSSI RSSI: NSNumber)
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
class DoorLockCommunicator: NSObject {
    
    /// Set this to handle callbacks
    var delegate: DoorLockCommunicatorDelegate?
    
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
    
    // MARK: - Private Methods
    init(delegate: DoorLockCommunicatorDelegate? = nil) {
        super.init()
        
        // Set delegate
        self.delegate = delegate
        
        // Begin looking for elements
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // MARK: - Public
    
    /// Sends the bytes provided to Arduino using Bluetooth
    func send<T: DataConvertible>(value: T) {
        if( self.isReady ) {
            guard let characterist = self.characterist else { return }
            self.peripheral?.writeValue(value.data, for: characterist, type: .withoutResponse)
        }
    }
    /// Read data from Arduino Module, if possible
    func read() {
        if( self.isReady ) {
            guard let characterist = self.characterist else { return }
            self.peripheral?.readValue(for: characterist)
        }
    }
}

extension DoorLockCommunicator: CBCentralManagerDelegate {
    
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

extension DoorLockCommunicator: CBPeripheralDelegate {
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
        if( characteristic.uuid.uuidString == characteristOfInterest.uuid.uuidString ) {
            
            // Allows the delegate to handle data exchange (read)
            self.delegate?.communicator(self, didRead: data)
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
        print("RSSI: \(RSSI.doubleValue)")
    }
}
