//
//  ConnectedPeripheralView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import SwiftUI

struct QRPeripheralView: View {
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
        EmptyView()
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

struct ConfirmationPeripheralView: View {
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var central: CentralDevice
    @ObservedObject var order: Order
    @Binding var transaction: Transaction?

    init(_ peripheral: Peripheral, _ central: CentralDevice, _ order: Order, _ transaction: Binding<Transaction?>) {
        self.device = .init(peripheral)
        self.central = central
        self.order = order
        _transaction = transaction
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
            }.onAppear {
                if device.peripheral.state == .disconnected {
                    print("Reconnecting...")
                    _ = central.centralManager.connect(device.peripheral)
                }
            }.onChange(of: device.peripheral.state) {
                if device.peripheral.state == .disconnected {
                    print("Retry Reconnecting...")
                    _ = central.centralManager.connect(device.peripheral)
                }
            }.disabled(device.peripheral.state == .disconnected)

            if let result = device.writeResponseResult {
                ProgressView()
                    .onAppear {
                        switch result {
                        case .success:
                            let newTransaction = Transaction(order: order)
                            transaction = newTransaction
                            return print("Received message confirmation")
                        case let .failure(error):
                            return print("\(error)")
                        }
                    }
            }

            // TODO: Finish confirmation of Payment by somehow getting this result value's success to trigger something
            // TODO: Get the confirmation of QR code reader to grey out QR code as well.
//            label(for: device.writeResponseResult)
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
