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
    var banks = ["Example", "other", "either"]
    @State var bank = "Example"
    var maxTransfer: Double {
        if transfer.type == .deposit {
            return Transfer.maxDeposit
        } else {
            return user.activeProfile?.availableFunds ?? 0
        }
    }

    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "yo_NG")
        return formatter
    }()

    var body: some View {
        VStack {
            Button("Dismiss") {
                dismiss()
            }
            Text(transfer.type.rawValue.capitalized)
            TextField("Enter Amount", value: $transferAmount, formatter: currencyFormatter)
                .padding()
            Text("Out of: \(maxTransfer)")

            Picker("Transfer to:", selection: $bank) {
                ForEach(banks, id: \.self) { name in
                    Text(name)
                }
            }

            Button("Transfer \(transferAmount)") {}
        }
    }
}

#Preview {
    TransferView(transfer: Transfer.example)
        .environmentObject(User())
}
