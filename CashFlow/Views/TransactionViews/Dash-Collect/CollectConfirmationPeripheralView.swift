//
//  CollectConfirmationPeripheralView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import CombineCoreBluetooth
import SwiftUI

struct CollectConfirmationPeripheralView: View {
    @EnvironmentObject var user: User
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var central: CentralDevice
    @ObservedObject var dash: Dash
    @Binding var transaction: Transaction?
    @Environment(\.dismiss) var dismiss
    @State var paying = false
    @State var cancelling = false
    @State var acceptDate = Date()

    init(_ peripheral: Peripheral, _ central: CentralDevice, _ dash: Dash, _ transaction: Binding<Transaction?>) {
        self.device = .init(peripheral)
        self.central = central
        self.dash = dash
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

        Button {
            acceptDate = Date()
            paying = true
        } label: {
            HStack {
                Text("Accept")
                Spacer()
                if paying {
                    FinishDashing(device, user, dash)
                }
            }
        }.disabled((device.peripheral.state != .connected) || paying)

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
                                date: acceptDate,
                                dash: dash,
                                payer: dash.from,
                                payee: user.activeProfile.name,
                                type: .dash
                            )
                            paying = false
                            user.addFunds(dash.amount)
                            transaction = newTransaction
                        } else {
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

struct FinishDashing: View {
    @ObservedObject var user: User
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var dash: Dash
    init(_ device: ConnectedPeripheral, _ user: User, _ dash: Dash) {
        self.device = device
        self.user = user
        self.dash = dash
        let confirmation = DashConfirmation(
            date: Date(),
            from: user.activeProfile.name,
            dash: dash
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

struct FinishCancelling: View {
    @ObservedObject var device: ConnectedPeripheral
    init(_ device: ConnectedPeripheral) {
        self.device = device
        let cancel = Cancel()

        if let data = try? JSONEncoder().encode(cancel) {
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
