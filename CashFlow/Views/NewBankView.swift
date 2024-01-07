//
//  NewBankView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/26/23.
//

import SwiftUI

struct NewBankView: View {
    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss
    let bankName = "Zenith Bank"
    let accountNumber = "0000000000"
    let birthDay = "2002-01-04"

    var body: some View {
        NavigationStack {
            Form {
                Section("New Bank") {
                    HStack {
                        Text("Bank Name:")
                        Spacer()
                        Text(bankName)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Account Number:")
                        Spacer()
                        Text(accountNumber)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Birthday:")
                        Spacer()
                        Text(birthDay)
                            .foregroundStyle(.secondary)
                    }

                    Button("Create") {
                        let newAccount = BankAccount(bankName: bankName)
                        if user.activeProfile.bankAccounts.isEmpty {
                            user.setPrimaryBank(newAccount)
                        }
                        user.addBank(newAccount)

                        dismiss()
                    }.disabled(bankName.count < 4)
                }
            }
            .navigationTitle("Bank Account Creation")
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
    NewBankView()
}
