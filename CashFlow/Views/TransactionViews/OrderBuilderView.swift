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
        if let profile = user.activeProfile {
            return profile.menuItems
        }
        return []
    }

    var body: some View {
        Form {
            Section("Order") {
                Button("Complete Order") {
                    dismiss()
                }.disabled(order.isEmpty)
                Button("Clear Cart") {
                    guard let profile = user.activeProfile else { return }
                    itemCounts = Array(repeating: 0, count: profile.menuItems.count)
                    order.clear()
                }.disabled(order.isEmpty)
            }

            Section("Menu") {
                ForEach(availableItems.indices, id: \.self) { i in
                    if (i < availableItems.count) && (i < itemCounts.count) {
                        HStack {
                            Text(availableItems[i].name)
                            Spacer()
                            Text(availableItems[i].cost, format: .currency(code: "USD"))
                            Spacer()
                            Picker("Count", selection: $itemCounts[i]) {
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
                guard let profile = user.activeProfile else { return }
                itemCounts = Array(repeating: 0, count: profile.menuItems.count)
                for item in order.items {
                    if let index = profile.menuItems.firstIndex(where: { $0.name == item.name }) {
                        itemCounts[index] = item.count
                    }
                }
            }
    }
}

#Preview {
    OrderBuilderView(order: Order())
}
