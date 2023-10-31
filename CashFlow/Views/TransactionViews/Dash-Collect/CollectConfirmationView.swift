//
//  CollectConfirmationView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/29/23.
//

import SwiftUI

struct CollectConfirmationView: View {
    @StateObject var peripheralDevice = PeripheralDevice()
    @EnvironmentObject var centralDevice: CentralDevice
    @Environment(\.dismiss) var dismiss
    @Binding var transaction: Transaction?

    var body: some View {
        Group {
            if let dash = peripheralDevice.receivedDash {
                Form {
                    Section("Amount") {
                        HStack {
                            Text("Received:")
                            Spacer()
                            Text(dash.amount, format: .currency(code: "USD"))
                        }
                    }

                    if let device = centralDevice.connectedPeripheral {
                        CollectConfirmationPeripheralView(device, centralDevice, dash, $transaction)

                    } else {
                        ForEach(centralDevice.peripherals) { discovery in
                            ProgressView()
                                .onAppear {
                                    centralDevice.connect(discovery)
                                }
                        }
                    }

                    Section {
                        Button(transaction == nil ? "Cancel" : "Exit") {
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Accept Dash")
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
            peripheralDevice.receivedOrder = nil
//            if let device = centralDevice.connectedPeripheral {
//                centralDevice.centralManager.cancelPeripheralConnection(device)
//            }
        }
    }
}
