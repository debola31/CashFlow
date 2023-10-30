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
            //            print("didSend")
        }
//        print("sent")
    }

    var body: some View {
        ProgressView()
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
    @State var paying = false

    init(_ peripheral: Peripheral, _ central: CentralDevice, _ order: Order, _ transaction: Binding<Transaction?>) {
        self.device = .init(peripheral)
        self.central = central
        self.order = order
        _transaction = transaction
    }

    var body: some View {
        Section {
            if device.peripheral.state != .connected {
                ForEach(central.peripherals) { discovery in
                    ProgressView()
                        .onAppear {
                            central.connect(discovery)
                        }
                }
            }

            if paying {
                if device.peripheral.state == .connected {
                    FinishPaying(device)
                }
            }

            Button("Pay") {
                print("Begin")
                if device.peripheral.state != .connected {
                    print("disconnected")
                } else {
//                    print("Trying")
                    paying = true
//                    device.write(
//                        data: Data("Pay".utf8),
//                        to: .writeResponseCharacteristic,
//                        type: .withResponse,
//                        result: \ConnectedPeripheral.$writeResponseResult
//                    )
//                    print("Tried")
                }
            }
            .disabled(device.peripheral.state != .connected)
            .onAppear {
                print("Peripheral State: \(device.peripheral.state)")
            }

            if let result = device.writeResponseResult {
                ProgressView()
                    .onAppear {
                        print("Appeared")
                        switch result {
                        case .success:
                            let newTransaction = Transaction(order: order)
                            paying = false
                            transaction = newTransaction
                            print("Received message confirmation")
                            return
                        case let .failure(error):
                            print("\(error)")
                            return
                        }
                    }
            }

            // TODO: Finish confirmation of Payment by somehow getting this result value's success to trigger something
            // TODO: Get the confirmation of QR code reader to grey out QR code as well.
//            label(for: device.writeResponseResult)
        }
    }
}

struct FinishPaying: View {
    @ObservedObject var device: ConnectedPeripheral
    init(_ device: ConnectedPeripheral) {
        self.device = device
        device.write(
            data: Data("Pay".utf8),
            to: .writeResponseCharacteristic,
            type: .withResponse,
            result: \ConnectedPeripheral.$writeResponseResult
        )
    }

    var body: some View {
        ProgressView()
    }
}

// #Preview {
//    ConnectedPeripheralView()
// }
