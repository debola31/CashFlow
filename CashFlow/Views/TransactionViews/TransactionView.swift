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
    @StateObject var order: Order
    @State var isShowingScanner = false
    @State var navPath = NavigationPath()
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
        isShowingScanner = false
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
                Button(actionText) {
                    switch transactionType {
                    case .pay, .collect, .refund:
                        isShowingScanner = true
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
                ConfirmationView(transaction: $transaction)
            }
            .navigationDestination(for: String.self, destination: { _ in
                QRCodeView(transaction: $transaction, order: order)
            })
            .navigationTitle(transactionType.rawValue.capitalized)
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
            .sheet(item: $transaction) { transaction in
                ReceiptView(navPath: $navPath, transaction: transaction)
            }
        }
    }
}

#Preview {
    TransactionView(transactionType: .pay)
        .environmentObject(User())
}
