//
//  ConfirmationPeripheralView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import SwiftUI

struct ConfirmationPeripheralView: View {
    @EnvironmentObject var user: User
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var central: CentralDevice
    @ObservedObject var order: Order
    @Environment(\.dismiss) var dismiss
    @Binding var transaction: Transaction?
    @State var paying = false
    @State var cancelling = false
    @State var paidDate = Date()

    init(_ peripheral: Peripheral, _ central: CentralDevice, _ order: Order, _ transaction: Binding<Transaction?>) {
        self.device = .init(peripheral)
        self.central = central
        self.order = order
        _transaction = transaction
    }

    var body: some View {
        if device.peripheral.state != .connected {
            ForEach(central.peripherals) { discovery in
                ProgressView()
                    .onAppear {
                        central.connect(discovery)
                    }
            }
        }

        Section {
            Button {
                paying = true
                paidDate = Date()
            } label: {
                HStack {
                    Text("Pay")
                    Spacer()
                    if paying {
                        FinishPaying(device, user, order)
                    }
                }
            }.disabled((device.peripheral.state != .connected) || paying || (order.totalCost > user.activeProfile.availableFunds))
        }
        footer: {
            if order.totalCost > user.activeProfile.availableFunds {
                Text("Insufficient Funds")
                    .foregroundStyle(.red)
            }
        }

        Section {
            Button {
                cancelling = true
            } label: {
                HStack {
                    Text("Cancel")
                    Spacer()
                    if cancelling {
                        FinishCancelling(device)
                    }
                }
            }.disabled((device.peripheral.state != .connected) || cancelling)
        }

        if let result = device.writeResponseResult {
            ProgressView()
                .onAppear {
                    switch result {
                    case .success:
                        if paying {
                            let newTransaction = Transaction(
                                date: paidDate,
                                order: order,
                                payer: user.activeProfile.name,
                                payee: order.to,
                                type: .bill
                            )
                            paying = false
                            user.takeOutFunds(order.finalCost)
                            transaction = newTransaction
                        }

                        else {
                            cancelling = false
                            dismiss()
                        }
                        return
                    case let .failure(error):
                        print("\(error)")
                        return
                    }
                }
        }
    }
}

struct FinishPaying: View {
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var user: User
    @ObservedObject var order: Order

    init(_ device: ConnectedPeripheral, _ user: User, _ order: Order) {
        self.device = device
        self.user = user
        self.order = order

        let confirmation = OrderConfirmation(
            date: Date(),
            from: user.activeProfile.name,
            order: order
        )

        if let data = try? JSONEncoder().encode(confirmation) {
            device.write(
                data: data,
                to: .writeResponseCharacteristic,
                type: .withResponse,
                result: \ConnectedPeripheral.$writeResponseResult
            )
        }
    }

    var body: some View {
        ProgressView()
    }
}
