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

    func evaluateAmount() {
        if dashAmount > user.activeProfile.availableFunds || dashAmount == 0 {
            disableTransaction = true
        } else {
            disableTransaction = false
        }
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
                Button("Generate Dash Code") {
                    dash.from = user.activeProfile.name
                    dash.amount = dashAmount
                    dashAmount = 0
                    navPath.append(dash)
                }
                .font(.title3)
                .buttonStyle(.plain)
                .padding(30)
                .background(disableTransaction ? .gray : .brown)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(disableTransaction)

                Section("Dash Amount") {
                    TextField("Dash Amount", value: $dashAmount, format: .currency(code: "USD"))
                        .onChange(of: dashAmount) {
                            evaluateAmount()
                        }
                        .onAppear(perform: evaluateAmount)
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
            .navigationTitle("Dash")
            .navigationDestination(for: Dash.self, destination: { _ in
                DashCodeView(transaction: $transaction)
                    .environmentObject(dash)
            })
            .sheet(item: $transaction) { transaction in
                ReceiptView(navPath: $navPath, transaction: transaction)
            }
        }
    }
}

#Preview {
    DashView()
}
