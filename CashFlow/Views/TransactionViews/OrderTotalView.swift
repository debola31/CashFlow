//
//  OrderTotalView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/28/23.
//

import SwiftUI

struct OrderTotalView: View {
    @ObservedObject var order: Order

    var body: some View {
        Section {
            HStack {
                Text("Total:")
                Spacer()
                Text(order.totalCost, format: .currency(code: "USD"))
            }
        }.onAppear(perform: order.calculateTotal)

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
}

#Preview {
    OrderTotalView(order: Order())
}
