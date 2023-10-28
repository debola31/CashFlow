//
//  Bluetooth.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import SwiftUI

extension CBUUID {
    static let service = CBUUID(string: "1337")
    static let writeResponseCharacteristic = CBUUID(string: "0001")
    static let writeNoResponseCharacteristic = CBUUID(string: "0002")
    static let writeBothResponseAndNoResponseCharacteristic = CBUUID(string: "0003")
}

class CentralDevice: ObservableObject {
    let centralManager: CentralManager = .live()
    @Published var peripherals: [PeripheralDiscovery] = []
    var scanTask: AnyCancellable?
    @Published var peripheralConnectResult: Result<Peripheral, Error>?
    @Published var scanning: Bool = false

    var connectedPeripheral: Peripheral? {
        guard case let .success(value) = peripheralConnectResult else { return nil }
        return value
    }

    var connectError: Error? {
        guard case let .failure(value) = peripheralConnectResult else { return nil }
        return value
    }

    func searchForPeripherals() {
        scanTask = centralManager.scanForPeripherals(withServices: [CBUUID.service])
            .scan([]) { list, discovery -> [PeripheralDiscovery] in
                guard !list.contains(where: { $0.id == discovery.id }) else { return list }
                return list + [discovery]
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.peripherals = $0
            })
        scanning = centralManager.isScanning
    }

    func stopSearching() {
        scanTask = nil
        peripherals = []
        scanning = centralManager.isScanning
    }

    func connect(_ discovery: PeripheralDiscovery) {
        centralManager.connect(discovery.peripheral)
            .map(Result.success)
            .catch { Just(Result.failure($0)) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$peripheralConnectResult)
    }
}
