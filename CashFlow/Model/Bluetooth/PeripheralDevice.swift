//
//  PeripheralDevice.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import SwiftUI

class PeripheralDevice: ObservableObject {
    let peripheralManager = PeripheralManager.live()
    @Published var logs: String = ""
    @Published var advertising: Bool = false
    var cancellables = Set<AnyCancellable>()

    init() {
        peripheralManager.didReceiveWriteRequests
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requests in
                guard let self = self else { return }
                print(requests.map { r in
                    "Write to \(r.characteristic.uuid), value: \(String(bytes: r.value ?? Data(), encoding: .utf8) ?? "<nil>")"
                }.joined(separator: "\n"), to: &self.logs)

                self.peripheralManager.respond(to: requests[0], withResult: .success)
            }
            .store(in: &cancellables)
    }

    func buildServices() {
        let service1 = CBMutableService(type: .service, primary: true)
        let writeCharacteristic = CBMutableCharacteristic(
            type: .writeResponseCharacteristic,
            properties: .write,
            value: nil,
            permissions: .writeable
        )

        service1.characteristics = [
            writeCharacteristic
        ]
        peripheralManager.removeAllServices()
        peripheralManager.add(service1)
    }

    func start() {
        peripheralManager.startAdvertising(.init([.serviceUUIDs: [CBUUID.service]]))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in

            }, receiveValue: { [weak self] _ in
                self?.advertising = true
                self?.buildServices()
            })
            .store(in: &cancellables)
    }

    func stop() {
        peripheralManager.stopAdvertising()
        cancellables = []
        advertising = false
    }
}
