//
//  OrderView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import CodeScanner
import CoreBluetooth
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ChargeView: View {
    @EnvironmentObject var user: User
    @StateObject var order: Order
    @State var isShowingScanner = false
    @State var navPath = NavigationPath()
    @State var disableTransaction = false
    @State var transaction: Transaction?

    init(transactionType: Transaction.types) {
        if let data = UserDefaults.standard.data(forKey: MenuItem.orderSaveKey) {
            if let decoded = try? JSONDecoder().decode(Order.self, from: data) {
                _order = StateObject(wrappedValue: decoded)
                return
            }
        }
        _order = StateObject(wrappedValue: Order())
    }

    func evaluationTransaction() {
        if order.isEmpty {
            disableTransaction = true
        } else {
            disableTransaction = false
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            // Set Bluetooth Service String
            CBUUID.service = CBUUID(string: result.string)
            navPath.append(order)

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
                Button("Generate Invoice Code") {
                    order.from = user.activeProfile.name
                    navPath.append(order)
                }
                .font(.title3)
                .buttonStyle(.plain)
                .padding(30)
                .background(disableTransaction ? .gray : .blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(disableTransaction)
                .onAppear(perform: evaluationTransaction)
                .onChange(of: order.isEmpty) {
                    evaluationTransaction()
                }

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
            .navigationTitle("Bill")
            .navigationDestination(for: Order.self, destination: { _ in
                QRCodeView(transaction: $transaction, order: order)
            })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
            .sheet(item: $transaction) { transaction in
                ReceiptView(navPath: $navPath, transaction: transaction)
            }
        }
    }
}
