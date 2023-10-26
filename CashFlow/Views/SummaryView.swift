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

    var body: some View {
        NavigationView {
            List {
                if let activeProfile = user.activeProfile {
                    Text("Profile: \(activeProfile.name)")

                    Text("Funds: \(activeProfile.availableFunds)")
                    Button("Deposit") {
                        transfer = Transfer(type: .deposit)
                    }
                    Button("Withdraw") {
                        transfer = Transfer(type: .withdrawal)
                    }
                    NavigationLink("Account History") {
                        Text("Account History")
                    }
                } else {
                    Button("Create New Profile") {}
                }
            }
            .navigationTitle("CashFlow")
            

        }.sheet(item: $transfer) { transfer in
            TransferView(transfer: transfer)
        }
    }
}

#Preview {
    SummaryView()
        .environmentObject(User())
}