//
//  ReceiptView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct ReceiptView: View {
    @Environment(\.dismiss) var dismiss
//    @Binding var navPath: NavigationPath
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
                Button("Close") {
                    //                navPath = NavigationPath()
                    dismiss()
                }
            }
            .navigationTitle("Receipt")
        }
    }
}

// #Preview {
//    ReceiptView(navPath: .constant(NavigationPath()), transaction: Transaction.example)
// }
