//
//  ReceiptView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct ReceiptView: View {
    @Binding var navPath: NavigationPath
    let transaction: Transaction
    var body: some View {
        VStack {
            Text("here is your receipt")
            Text("Date of Purchase: \(transaction.date)")
            if let order = transaction.order {
                Section("Total") {
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text(order.finalCost, format: .currency(code: "USD"))
                    }
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
                navPath = NavigationPath()
            }
        }
    }
}

#Preview {
    ReceiptView(navPath: .constant(NavigationPath()), transaction: Transaction.example)
}
