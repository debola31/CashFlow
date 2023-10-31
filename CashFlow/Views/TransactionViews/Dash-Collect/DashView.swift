//
//  DashView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/29/23.
//

import SwiftUI

struct DashView: View {
    @EnvironmentObject var user: User
    @State var navPath = NavigationPath()
    @State var disableTransaction = false
    @State var transaction: Transaction?
    @State var dashAmount: Double = 0
    @StateObject var dash = Dash()

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
                Button(Transaction.types.dash.actionText) {
                    dash.amount = dashAmount
                    navPath.append(dash)
                }
                .font(.title3)
                .buttonStyle(.plain)
                .padding(30)
                .background(.brown)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(disableTransaction)

                Section("Dash Amount") {
                    TextField("Dash Amount", value: $dashAmount, format: .currency(code: "USD"))
                    HStack {
                        Text("Max:")
                        Text(user.activeProfile.availableFunds, format: .currency(code: "USD"))
                    }
                    .foregroundStyle(.secondary)
                    Button("Clear") {
                        dashAmount = 0
                    }
                }
            }
            .navigationTitle(Transaction.types.dash.rawValue.capitalized)
            .navigationDestination(for: Dash.self, destination: { dash in
                DashCodeView(transaction: $transaction)
                    .environmentObject(dash)
            })
        }
    }
}

#Preview {
    DashView()
}
