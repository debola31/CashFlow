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
    @State private var bankName = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("New Bank") {
                    TextField("Enter bank name", text: $bankName)
                        .autocorrectionDisabled()
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
