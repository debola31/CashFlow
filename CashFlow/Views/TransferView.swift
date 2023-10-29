//
//  TransferView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct TransferView: View {
    var transfer: Transfer
    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss
    @State var transferAmount: Double = 0
    @State private var bankSelection = 0
    var maxTransfer: Double {
        var maxDeposit: Double = 0
        if user.activeProfile.type == .business {
            maxDeposit = 10_000_000
        } else {
            maxDeposit = 100_000
        }

        if transfer.type == .deposit {
            return maxDeposit - user.activeProfile.availableFunds
        } else {
            return user.activeProfile.availableFunds
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Enter \(transfer.type.rawValue.capitalized) Amount") {
                    TextField("Enter Amount", value: $transferAmount, format: .currency(code: "USD"))
                        .font(.headline)
                        .padding(.bottom, 5)
                    HStack {
                        Text("Max:")
                        Text(maxTransfer, format: .currency(code: "USD"))
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 5)
                }

                if user.hasBanks {
                    Picker(transfer.type == .deposit ? "From:" : "To:", selection: $bankSelection) {
                        ForEach(user.activeProfile.bankAccounts.indices, id: \.self) { selection in
                            if selection < user.activeProfile.bankAccounts.count {
                                Text("\(user.activeProfile.bankAccounts[selection].bankName)")
                            }
                        }
                    }

                    Button {
                        if transfer.type == .deposit {
                            user.addFunds(transferAmount)
                        } else {
                            user.takeOutFunds(transferAmount)
                        }

                        dismiss()

                    } label: {
                        HStack {
                            Text(transfer.type.rawValue.capitalized)
                            Text(transferAmount, format: .currency(code: "USD"))
                        }
                    }
                    .disabled(transferAmount > maxTransfer || transferAmount == 0)
                } else {
                    Text("No Accounts in Profile")
                }
            }
            .navigationTitle(transfer.type.rawValue.capitalized)
            .toolbar {
                ToolbarItem {
                    Button("Exit") {
                        dismiss()
                    }.padding(5)
                }
            }
        }
    }
}

#Preview {
    TransferView(transfer: Transfer.example)
        .environmentObject(User())
}
