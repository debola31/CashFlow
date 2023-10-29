//
//  ConnectedPeripheralView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import SwiftUI

struct ConnectedPeripheralView: View {
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var central: CentralDevice
    @ObservedObject var order: Order

    init(_ peripheral: Peripheral, _ central: CentralDevice, _ order: Order) {
        self.device = .init(peripheral)
        self.central = central
        self.order = order

        if let data = try? JSONEncoder().encode(order.items) {
            device.write(
                data: data,
                to: .writeResponseCharacteristic,
                type: .withResponse,
                result: \ConnectedPeripheral.$writeResponseResult
            )
            print("didSend")
        }
        print("sent")
    }

    var body: some View {
        Section("Characteristic sends response") {
            Button("Write with response") {
                if device.peripheral.state == .disconnected {
                    print("disconnected")
                } else {
                    device.write(
                        data: Data("Hello".utf8),
                        to: .writeResponseCharacteristic,
                        type: .withResponse,
                        result: \ConnectedPeripheral.$writeResponseResult
                    )
                }
            }
            label(for: device.writeResponseResult)
        }
    }

    func label<T>(for result: Result<T, Error>?) -> some View {
        Group {
            switch result {
            case let .success(value)?:
                Text("Wrote at \(String(describing: value))")
            case let .failure(error)?:
                if let error = error as? LocalizedError, let errorDescription = error.errorDescription {
                    Text("Error: \(errorDescription)")
                } else {
                    Text("Error: \(String(describing: error))")
                }
            case nil:
                EmptyView()
            }
        }
    }
}

struct ConnectedPeripheralView2: View {
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var central: CentralDevice
    @ObservedObject var order: Order

    init(_ peripheral: Peripheral, _ central: CentralDevice, _ order: Order) {
        self.device = .init(peripheral)
        self.central = central
        self.order = order
//        let random = Int.random(in: 1 ... 100)
//
//        if let data = try? JSONEncoder().encode(order.items) {
//            device.write(
//                data: Data("Pay\(random)".utf8),
//                to: .writeResponseCharacteristic,
//                type: .withResponse,
//                result: \ConnectedPeripheral.$writeResponseResult
//            )
//            print("didSend")
//        }
//        print("sent")
    }

    var body: some View {
        Section {
            Button("Pay") {
                if device.peripheral.state == .disconnected {
                    print("disconnected")
                } else {
                    device.write(
                        data: Data("Pay".utf8),
                        to: .writeResponseCharacteristic,
                        type: .withResponse,
                        result: \ConnectedPeripheral.$writeResponseResult
                    )
                }
            }
            label(for: device.writeResponseResult)
        }
    }

    func label<T>(for result: Result<T, Error>?) -> some View {
        Group {
            switch result {
            case let .success(value)?:
                Text("Wrote at \(String(describing: value))")
            case let .failure(error)?:
                if let error = error as? LocalizedError, let errorDescription = error.errorDescription {
                    Text("Error: \(errorDescription)")
                } else {
                    Text("Error: \(String(describing: error))")
                }
            case nil:
                EmptyView()
            }
        }
    }
}

// #Preview {
//    ConnectedPeripheralView()
// }
