//
//  MenuBuilderView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/26/23.
//

import SwiftUI

struct MenuBuilderView: View {
    @EnvironmentObject var user: User
    @Binding var billMenu: [MenuItem]
    var availableItems: [MenuItem] {
        if let profile = user.activeProfile {
            return profile.menuItems
        }
        return []
    }

    var body: some View {
        Form {
            Button("Reset Items") {}
            ForEach(availableItems) { item in
                HStack {
                    Text(item.name)
                    Text(item.cost)
                }
            }

        }.navigationTitle("Menu Builder")
    }
}

#Preview {
    MenuBuilderView(billMenu: .constant([MenuItem]()))
}
