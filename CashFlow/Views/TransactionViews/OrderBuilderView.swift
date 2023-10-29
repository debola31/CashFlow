//
//  OrderBuilderView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/26/23.
//

import SwiftUI

struct OrderBuilderView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: User
    @ObservedObject var order: Order
    @State private var itemCounts = [Int]()
    var countOptions = 0 ... 9
    var availableItems: [MenuItem] {
        user.activeProfile.menuItems
    }

    var body: some View {
        Form {
            Section("Order") {
                Button("Complete Order") {
                    dismiss()
                }.disabled(order.isEmpty)
                Button("Clear Cart") {
                    itemCounts = Array(repeating: 0, count: user.activeProfile.menuItems.count)
                    order.clear()
                }.disabled(order.isEmpty)
            }

            Section("Menu") {
                ForEach(availableItems.indices, id: \.self) { i in
                    if (i < availableItems.count) && (i < itemCounts.count) {
                        HStack {
                            Text(availableItems[i].name)
                            Text(availableItems[i].cost, format: .currency(code: "USD"))
                            Spacer()
                            Picker("", selection: $itemCounts[i]) {
                                ForEach(countOptions, id: \.self) { option in
                                    Text(option, format: .number)
                                }
                            }.onChange(of: itemCounts[i]) {
                                var item = availableItems[i]
                                item.count = itemCounts[i]
                                order.edit(item)
                            }
                        }
                    }
                }
            }

        }.navigationTitle("Menu Builder")
            .onAppear {
                itemCounts = Array(repeating: 0, count: user.activeProfile.menuItems.count)
                for item in order.items {
                    if let index = user.activeProfile.menuItems.firstIndex(where: { $0.name == item.name }) {
                        itemCounts[index] = item.count
                    }
                }
            }
    }
}

#Preview {
    OrderBuilderView(order: Order())
}
