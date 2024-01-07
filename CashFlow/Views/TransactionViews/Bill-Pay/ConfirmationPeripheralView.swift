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
    @Environment(\.dismiss) var dismiss
    @ObservedObject var invoice: Bill
    @Binding var bill: Bill?
    @State var paying = false
    @State var cancelling = false

    init(_ peripheral: Peripheral, _ central: CentralDevice, _ invoice: Bill, _ bill: Binding<Bill?>) {
        self.device = .init(peripheral)
        self.central = central
        self.invoice = invoice
        _bill = bill
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
                invoice.payer = Person(id: user.activeProfile.id, name: user.activeProfile.name)
                invoice.date = Date()
                paying = true
            } label: {
                HStack {
                    Text("Pay")
                    Spacer()
                    if paying {
                        FinishPaying(device, user, invoice)
                    }
                }
            }.disabled((device.peripheral.state != .connected) || paying || (invoice.amount > user.activeProfile.availableFunds))
        }
        footer: {
            if invoice.amount > user.activeProfile.availableFunds {
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
                            paying = false
                            user.takeOutFunds(invoice.amount)
                            invoice.payer = Person(id: user.activeProfile.id, name: user.activeProfile.name)
                            bill = invoice
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
    @ObservedObject var invoice: Bill

    init(_ device: ConnectedPeripheral, _ user: User, _ invoice: Bill) {
        self.device = device
        self.user = user
        self.invoice = invoice

        let confirmation = BillConfirmation(
            date: Date(),
            invoice: invoice
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
