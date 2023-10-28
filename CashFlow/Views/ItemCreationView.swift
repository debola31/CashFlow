//
//  MenuCreationView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/26/23.
//

import SwiftUI

struct MenuCreationView: View {
    @EnvironmentObject var user: User
    @State private var filterOption = "All"
    @State private var newItemName = ""
    @State private var newItemCost: Double = 0
    var items: [MenuItem] {
        if let profile = user.activeProfile {
            return profile.menuItems
        }
        return []
    }

    var options = ["All", "Items Only", "Add Ons Only"]
    var body: some View {
        Form {
            Section("Add New") {
                TextField("Name", text: $newItemName, prompt: Text("Enter Name"))
                TextField("Cost", value: $newItemCost, format: .currency(code: "NGN"), prompt: Text("Enter Cost"))
                Button("Create New Item") {
                    if let _ = user.activeProfile {
                        let newItem = MenuItem(name: newItemName, cost: newItemCost)
                        user.activeProfile?.menuItems.append(newItem)
                    }
                }
            }

            Section("Items") {
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                            .padding(.trailing)
                        Spacer()
                        Text(item.cost, format: .currency(code: "USD"))
                    }
                }
            }
        }
        .navigationTitle("Service Menu")
    }
}

#Preview {
    MenuCreationView()
}
