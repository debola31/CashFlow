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
    @State var transaction: Transaction?
    var peripheralConnected = false

    var body: some View {
        Group {
            if let order = peripheralDevice.receivedOrder {
                Text("Confirm Order")
                    .font(.largeTitle)
                    .padding()

                Form {
                    OrderTotalView(order: order)

                    Section("Discovered peripherals") {
                        ForEach(centralDevice.peripherals) { discovery in
                            Button(discovery.peripheral.name ?? "<nil>") {
                                centralDevice.connect(discovery)
                            }
                            .onAppear {
                                centralDevice.connect(discovery)
                            }
                        }
                    }

                    if let device = centralDevice.connectedPeripheral {
                        ConnectedPeripheralView2(device, centralDevice, order)
//                        Button("Pay") {
//                            let peripheral = ConnectedPeripheral(device)
//                            if let data = try? JSONEncoder().encode(order.items) {
//                                peripheral.write(
//                                    data: Data("Pay".utf8),
//                                    to: .writeResponseCharacteristic,
//                                    type: .withResponse,
//                                    result: \ConnectedPeripheral.$writeResponseResult
//                                )
//                                print("didSend")
//                            }
//                            transaction = Transaction(order: order)
//                        }
//
//                        Button("Cancel") {
//                            let peripheral = ConnectedPeripheral(device)
//                            if let data = try? JSONEncoder().encode(order.items) {
//                                peripheral.write(
//                                    data: Data("Cancel".utf8),
//                                    to: .writeResponseCharacteristic,
//                                    type: .withResponse,
//                                    result: \ConnectedPeripheral.$writeResponseResult
//                                )
//                                print("didSend")
//                            }
//                            navPath = NavigationPath()
//                        }
                    }

                    if let transaction = transaction {
                        Button("Exit") {
                            navPath = NavigationPath()
                        }
                        Button("View Receipt") {
                            navPath.append(transaction)
                        }
                    }

                    Text(peripheralDevice.logs)
                }
            } else {
                ProgressView()
            }
//            Text("Hello, World!")
//            Button("Slide to Confirm") {
//                navPath = NavigationPath()
//            }
//            Button("View Receipt") {
//                let record = Record(transaction: transaction)
//                navPath.append(record)
//            }

//            Text(peripheralDevice.logs)
        }
        .onAppear {
            peripheralDevice.start()
            centralDevice.searchForPeripherals()
        }
        .onDisappear {
            peripheralDevice.receivedOrder = nil
        }
    }
}

// #Preview {
//    ConfirmationView(navPath: .constant(NavigationPath()))
// }
