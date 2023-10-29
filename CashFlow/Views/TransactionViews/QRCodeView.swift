//
//  QRCodeView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/28/23.
//

import CombineCoreBluetooth
import SwiftUI

struct QRCodeView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var centralDevice: CentralDevice
    @StateObject var peripheralDevice = PeripheralDevice()
    @Environment(\.dismiss) var dismiss
    @ObservedObject var order: Order
    @State private var qrCode = UIImage()
    @State var transactionComplete = false

    func loadCode() {
        CBUUID.service = CBUUID(string: UUID().uuidString)
        qrCode = centralDevice.generateQRCode(from: CBUUID.service.uuidString)
    }

    var body: some View {
        if transactionComplete {
            Text("Payment Complete")
                .font(.largeTitle)

            Button("Exit") {
                dismiss()
            }
        } else {
            VStack {
                Text("Scan Invoice Code")
                    .font(.largeTitle)
                    .padding(.vertical, 20)
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)

                Button("Cancel") {
                    dismiss()
                }
                .padding(20)
                .font(.headline)
                .foregroundStyle(.white)
                .background(.black)
                .clipShape(Capsule())
                .padding(.vertical, 20)

                Form {
                    Section {
                        Button("Search for Peripheral") {
                            centralDevice.searchForPeripherals()
                        }.disabled(centralDevice.scanning)

                        Button("Stop Searching") {
                            centralDevice.stopSearching()
                        }
                    }

                    Section {
                        if let device = centralDevice.connectedPeripheral {
                            Text("Connected to \(device.name ?? "nil")")
                            Button("disconnect") {
                                centralDevice.peripheralConnectResult = nil
                            }
                            ConnectedPeripheralView(device, centralDevice, order)

                        } else {
                            Section("Discovered peripherals") {
                                ForEach(centralDevice.peripherals) { discovery in
                                    Button(discovery.peripheral.name ?? "<nil>") {
                                        centralDevice.connect(discovery)
                                    }.onAppear {
                                        centralDevice.connect(discovery)
                                    }
                                }
                            }
                        }
                    }

                    Section {
                        Text(peripheralDevice.logs)
                    }
                }
            }
            .onAppear {
                loadCode()
                centralDevice.searchForPeripherals()
                peripheralDevice.start()
            }
            .onDisappear {
                centralDevice.stopSearching()
                centralDevice.peripheralConnectResult = nil
            }
            .onChange(of: peripheralDevice.response) {
                transactionComplete = true
            }
        }
    }
}

#Preview {
    QRCodeView(order: Order())
}
