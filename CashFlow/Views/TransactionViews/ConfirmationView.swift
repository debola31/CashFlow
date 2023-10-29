//
//  ConfirmationView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import CoreBluetooth
import SwiftUI

struct ConfirmationView: View {
    @Binding var navPath: NavigationPath
    @StateObject var peripheralDevice = PeripheralDevice()
    @EnvironmentObject var centralDevice: CentralDevice
    @Binding var transaction: Transaction?
    var peripheralConnected = false

    var body: some View {
        Group {
            if let order = peripheralDevice.receivedOrder {
                Form {
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

                    Section {
                        Button(transaction == nil ? "Cancel" : "Exit") {
                            navPath = NavigationPath()
                        }
                    }

                    if let transaction = transaction {
                        Section {
                            Button("View Receipt") {
                                navPath.append(transaction)
                            }
                        }
                    }

//                    Text(peripheralDevice.logs)
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

// #Preview {
//    ConfirmationView(navPath: .constant(NavigationPath()))
// }
