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
    @Published var receivedOrder: Order?
    @Published var receivedDash: Dash?
    @Published var receivedDashConfirmation: DashConfirmation?
    @Published var receivedOrderConfirmation: OrderConfirmation?
    var cancellables = Set<AnyCancellable>()

    init() {
        peripheralManager.didReceiveWriteRequests
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requests in
                guard let self = self else { return }
                print("Received something")

                print(requests.map { r in
                    "Write to \(r.characteristic.uuid), value: \(String(bytes: r.value ?? Data(), encoding: .utf8) ?? "<nil>")"
                }.joined(separator: "\n"), to: &self.logs)

                _ = requests.map { r in

                    if let order = try? JSONDecoder().decode(Order.self, from: r.value ?? Data()) {
                        print("Received Order")
                        self.receivedOrder = order
                    }

                    if let dash = try? JSONDecoder().decode(Dash.self, from: r.value ?? Data()) {
                        print("Received Dash")
                        self.receivedDash = dash
                    }

                    if let confirmation = try? JSONDecoder().decode(DashConfirmation.self, from: r.value ?? Data()) {
                        print("Received Confirmation")
                        self.receivedDashConfirmation = confirmation
                    }

                    if let confirmation = try? JSONDecoder().decode(OrderConfirmation.self, from: r.value ?? Data()) {
                        print("Received Confirmation")
                        self.receivedOrderConfirmation = confirmation
                    }
                }

                for request in requests {
//                    for _ in 1 ... 10 {
                    self.peripheralManager.respond(to: request, withResult: .success)
//                    }
                }
                print("responded")
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
        peripheralManager.removeAllServices()
        cancellables = []
        advertising = false
    }
}
