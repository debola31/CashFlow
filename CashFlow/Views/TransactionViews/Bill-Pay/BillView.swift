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

struct BillView: View {
    @EnvironmentObject var user: User
    @StateObject var order: Order
    @State var isShowingScanner = false
    @State var navPath = NavigationPath()
    @State var disableTransaction = false
    @State var transaction: Transaction?

    init() {
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

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
                Button("Generate Invoice Code") {
                    order.to = user.activeProfile.name
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
            .sheet(item: $transaction) { transaction in
                ReceiptView(navPath: $navPath, transaction: transaction)
                    .onAppear {
                        order.clear()
                    }
            }
        }
    }
}
