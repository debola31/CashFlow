//
//  SummaryView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import SwiftUI
struct SummaryView: View {
    @EnvironmentObject var user: User
    @State var transfer: Transfer?
    @Binding var profileChange: Bool
    var profileText: String {
        return "\(user.activeProfile.name) " + "\(user.activeProfile.type == .individual ? "🙂" : "💼")"
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Active Profile") {
                    Button {
                        profileChange = true
                    } label: {
                        HStack {
                            Text("Select Profile:")
                            Spacer()
                            Text(profileText)
                        }
                    }
                }

                Section("Account Summary") {
                    HStack {
                        Text("Funds: ")
                        Spacer()
                        Text(user.activeProfile.availableFunds, format: .currency(code: "USD"))
                    }
                    Button("Deposit") {
                        transfer = Transfer(type: .deposit)
                    }
                    Button("Withdraw") {
                        transfer = Transfer(type: .withdrawal)
                    }
                }

                Section {
                    NavigationLink("Account History") {
                        Text("Account History")
                    }
                }
            }
            .navigationTitle("CashFlow")

        }.sheet(item: $transfer) { transfer in
            TransferView(transfer: transfer)
        }
    }
}

#Preview {
    SummaryView(profileChange: .constant(true))
        .environmentObject(User())
}
