//
//  HistoryItemView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import SwiftUI

struct HistoryItemView: View {
    let transaction: Transaction
    var body: some View {
        Section {
            HStack {
                Text("Date:")
                Spacer()
                Text(transaction.date, format: .dateTime)
            }

            HStack {
                Text("Transaction Type:")
                Spacer()
                Text(transaction.dash == nil ? "BillPay" : "Dash")
            }

            if let order = transaction.order {
                HStack {
                    Text("Business:")
                    Spacer()
                    Text(transaction.payee ?? "")
                }

                HStack {
                    Text("Client:")
                    Spacer()
                    Text(transaction.payer ?? "")
                }

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
                    Text("Amount:")
                    Spacer()
                    Text(dash.amount, format: .currency(code: "USD"))
                }
            }
        }
    }
}

#Preview {
    HistoryItemView(transaction: Transaction.example)
}
