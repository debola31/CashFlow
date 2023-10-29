//
//  TransactionView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import CodeScanner
import CoreBluetooth
import CoreImage.CIFilterBuiltins
import SwiftUI

struct TransactionView: View {
    let transactionType: Transaction.types
    @EnvironmentObject var user: User
    @State var isShowingSheet = false
    @State var navPath = NavigationPath()
    @StateObject var order: Order
    @State var activeChar = CBUUID.writeResponseCharacteristic.uuidString
    @State var disableTransaction = false
    @State var transaction: Transaction?

    init(transactionType: Transaction.types) {
        self.transactionType = transactionType
        if let data = UserDefaults.standard.data(forKey: MenuItem.orderSaveKey) {
            if let decoded = try? JSONDecoder().decode(Order.self, from: data) {
                _order = StateObject(wrappedValue: decoded)
                return
            }
        }
        _order = StateObject(wrappedValue: Order())
    }

    var actionText: String {
        switch transactionType {
        case .pay:
            return "Scan Invoice Code"
        case .dash:
            return "Generate Dash Code"
        case .collect:
            return "Scan Dash Code"
        case .charge:
            return "Generate Invoice Code"
        case .refund:
            return "Scan Refund Code"
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingSheet = false
        switch result {
        case .success(let result):
            // Set Bluetooth Service String
            CBUUID.service = CBUUID(string: result.string)
            navPath.append(0)

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
//                Section {
//                    Button("change characteristic") {
//                        CBUUID.writeResponseCharacteristic = CBUUID(string: "0001") // CBUUID(string: UUID().uuidString)
//                        activeChar = CBUUID.writeResponseCharacteristic.uuidString
//                    }
//                    Text("Active char: \(activeChar)")
//                }
//                Section {
//                    Button("Search for Peripheral") {
//                        centralDevice.searchForPeripherals()
//                    }.disabled(centralDevice.scanning)
//
//                    Button("Stop Searching") {
//                        centralDevice.stopSearching()
//                    }
//                }
//
//                Section {
//                    if let device = centralDevice.connectedPeripheral {
//                        Text("Connected to \(device.name ?? "nil")")
//                        Button("disconnect") {
//                            centralDevice.peripheralConnectResult = nil
//                        }
//                        ConnectedPeripheralView(device, centralDevice)
//
//                    } else {
//                        Section("Discovered peripherals") {
//                            ForEach(centralDevice.peripherals) { discovery in
//                                Button(discovery.peripheral.name ?? "<nil>") {
//                                    centralDevice.connect(discovery)
//                                }
//                            }
//                        }
//                    }
//                }
//
//                Section {
//                    Button("Start advertising") {
//                        peripheral.start()
//                    }.disabled(peripheral.advertising)
//
//                    Button("Stop advertising") {
//                        peripheral.stop()
//                    }
//
//                    Text("Logs:")
//                    Text(peripheral.logs)
//                }

                Button(actionText) {
//                    isShowingSheet = true
                    switch transactionType {
                    case .pay, .collect, .refund:
                        isShowingSheet = true
                    case .dash, .charge:
                        navPath.append("")
                    }
                }
                .font(.title3)
                .buttonStyle(.plain)
                .padding(30)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(disableTransaction)

                if transactionType == .charge {
                    Section("Build Menu") {
                        NavigationLink(order.items.isEmpty ? "Add to Cart" : "Edit Cart") {
                            OrderBuilderView(order: order)
                        }
                        Button("Clear Cart") {
                            order.clear()
                        }.disabled(order.isEmpty)
                    }

                    OrderTotalView(order: order)
                }
            }
            .navigationDestination(for: Int.self) { _ in
                ConfirmationView(navPath: $navPath, transaction: $transaction)
            }
//            .navigationDestination(for: Transaction.self, destination: { transaction in
            ////                ReceiptView(navPath: $navPath, transaction: transaction)
//                ReceiptView(isShowingQRCode: $isShowingSheet, transaction: transaction)
//            })
            .navigationDestination(for: String.self, destination: { _ in
                QRCodeView(transaction: $transaction, order: order)
            })
            .navigationTitle(transactionType.rawValue.capitalized)
            .sheet(isPresented: $isShowingSheet) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
//                switch transactionType {
//                case .pay, .collect, .refund:
//                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
//                case .dash, .charge:
//                    QRCodeView(transaction: $transaction, order: order)
//                }
            }
            .sheet(item: $transaction) { transaction in
                ReceiptView(transaction: transaction)
            }
        }
    }
}

#Preview {
    TransactionView(transactionType: .pay)
        .environmentObject(User())
}
