//
//  ReceiptView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct ReceiptView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navPath: NavigationPath
    let transaction: Transaction
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Date:")
                    Spacer()
                    Text(transaction.date, format: .dateTime)
                }

                if let order = transaction.order {
                    Text("Business name: \(transaction.payee ?? "")")
                    Text("Order by: \(transaction.payer ?? "")")
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text(order.finalCost, format: .currency(code: "USD"))
                    }

                    Section("Items") {
                        ForEach(order.items) { item in
                            HStack {
                                Text("\(item.count) * \(item.name)")
                                Spacer()
                                Text(Double(item.count) * item.cost, format: .currency(code: "USD"))
                            }
                        }
                    }
                }

                if let dash = transaction.dash {
                    Section("Details") {
                        HStack {
                            Text("From:")
                            Spacer()
                            Text(transaction.payer ?? "")
                        }

                        HStack {
                            Text("To:")
                            Spacer()
                            Text(transaction.payee ?? "")
                        }

                        HStack {
                            Text("Total:")
                            Spacer()
                            Text(dash.amount, format: .currency(code: "USD"))
                        }
                    }
                }

                Button("Close") {
                    navPath = NavigationPath()
                    dismiss()
                }
            }
            .navigationTitle("\(transaction.type.rawValue.capitalized) Receipt")
        }
    }
}
