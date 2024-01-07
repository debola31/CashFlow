//
//  SummaryView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import SwiftUI
struct SummaryView: View {
    @EnvironmentObject var user: User
    @Binding var profileChange: Bool

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
                            Text(user.activeProfile.name)
                        }
                    }
                }

                Section("Account Summary") {
                    HStack {
                        Text("Funds: ")
                        Spacer()
                        Text(user.activeProfile.availableFunds, format: .currency(code: "USD"))
                    }
                    NavigationLink("Deposit") {
                        TransferView(mode: .deposit)
                    }

                    NavigationLink("Withdraw") {
                        TransferView(mode: .withdrawal)
                    }
                }

                Section {
                    NavigationLink("Account History") {
                        AccountHistoryView()
                            .navigationTitle("Account History")
                    }
                }
            }
            .navigationTitle("CashFlow")
        }
    }
}

#Preview {
    SummaryView(profileChange: .constant(true))
        .environmentObject(User())
}
