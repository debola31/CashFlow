//
//  ItemCreationView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/26/23.
//

import SwiftUI

struct ItemCreationView: View {
    @EnvironmentObject var user: User
    @State private var newItemName = ""
    @State private var newItemCost: Double = 0
    var items: [MenuItem] {
        user.activeProfile.menuItems
    }

    var body: some View {
        Form {
            Section("Add New") {
                TextField("Name", text: $newItemName, prompt: Text("Enter Name"))
                TextField("Cost", value: $newItemCost, format: .currency(code: "USD"), prompt: Text("Enter Cost"))
                Button("Create New Item") {
                    let newItem = MenuItem(name: newItemName, cost: newItemCost)
                    user.addMenuItem(newItem)
                    newItemName = ""
                    newItemCost = 0
                }
                .disabled(newItemName.count < 3 || newItemCost == 0)
            }

            Section("Items") {
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                            .padding(.trailing)
                        Spacer()
                        Text(item.cost, format: .currency(code: "USD"))
                    }
                }.onDelete { IndexSet in
                    user.removeMenuItem(IndexSet)
                }
            }
        }
        .navigationTitle("Service Menu")
    }
}

#Preview {
    ItemCreationView()
}
