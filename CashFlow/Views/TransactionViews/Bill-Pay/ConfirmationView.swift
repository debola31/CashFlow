//
//  ConfirmationView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import CoreBluetooth
import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var user: User
    @StateObject var peripheralDevice = PeripheralDevice()
    @EnvironmentObject var centralDevice: CentralDevice
    @Environment(\.dismiss) var dismiss
    @Binding var bill: Bill?

    var body: some View {
        Group {
            if let invoice = peripheralDevice.receivedBill {
                Form {
                    Section("Invoice") {
                        HStack {
                            Text("From:")
                            Spacer()
                            Text(invoice.payee?.name ?? "")
                        }

                        HStack {
                            Text("Amount:")
                            Spacer()
                            Text(invoice.amount, format: .currency(code: "USD"))
                        }
                    }

                    Section("Balance") {
                        HStack {
                            Text("Current Balance:")
                            Spacer()
                            Text(user.activeProfile.availableFunds, format: .currency(code: "USD"))
                        }

                        HStack {
                            let newBalance = user.activeProfile.availableFunds - invoice.amount
                            Text("After Payment:")
                            Spacer()
                            Text(newBalance, format: .currency(code: "USD"))
                        }
                    }

                    if let device = centralDevice.connectedPeripheral {
                        ConfirmationPeripheralView(device, centralDevice, invoice, $bill)

                    } else {
                        ForEach(centralDevice.peripherals) { discovery in
                            ProgressView()
                                .onAppear {
                                    centralDevice.connect(discovery)
                                }
                        }
                    }
                }
                .navigationTitle("Confirm Payment")
            } else {
                ProgressView()
            }
        }
        .onAppear {
            peripheralDevice.start()
            centralDevice.searchForPeripherals()
        }
        .onDisappear {
            peripheralDevice.stop()
            peripheralDevice.receivedBill = nil
        }
    }
}
