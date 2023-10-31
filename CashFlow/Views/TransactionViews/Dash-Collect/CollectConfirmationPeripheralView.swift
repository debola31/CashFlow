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
    @State var acceptDate = Date()

    init(_ peripheral: Peripheral, _ central: CentralDevice, _ dash: Dash, _ transaction: Binding<Transaction?>) {
        self.device = .init(peripheral)
        self.central = central
        self.dash = dash
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

            Button {
                paying = true
                acceptDate = Date()
            } label: {
                HStack {
                    Text("Accept")
                    Spacer()
                    if paying && device.peripheral.state == .connected {
                        FinishDashing(device, user, dash)
                    }
                }
            }.disabled((device.peripheral.state != .connected) || paying)

            if let result = device.writeResponseResult {
                ProgressView()
                    .onAppear {
                        print("Appeared")
                        switch result {
                        case .success:
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
                            print("Received message confirmation")
                            return
                        case let .failure(error):
                            print("\(error)")
                            return
                        }
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
