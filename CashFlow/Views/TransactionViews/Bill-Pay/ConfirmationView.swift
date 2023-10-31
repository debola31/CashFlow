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
    @Binding var transaction: Transaction?

    var body: some View {
        Group {
            if let order = peripheralDevice.receivedOrder {
                Form {
                    Section("Available Funds") {
                        HStack {
                            Text("Funds:")
                            Spacer()
                            Text(user.activeProfile.availableFunds, format: .currency(code: "USD"))
                        }
                    }

                    OrderTotalView(order: order)

                    if let device = centralDevice.connectedPeripheral {
                        ConfirmationPeripheralView(device, centralDevice, order, $transaction)

                    } else {
                        ForEach(centralDevice.peripherals) { discovery in
                            ProgressView()
                                .onAppear {
                                    centralDevice.connect(discovery)
                                }
                        }
                    }
                }
                .navigationTitle("Confirm Order")
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
        }
    }
}
