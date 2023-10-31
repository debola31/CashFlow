//
//  AccountHistoryView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import SwiftUI

struct AccountHistoryView: View {
    @EnvironmentObject var user: User
    var body: some View {
        if user.activeProfile.accountHistory.isEmpty {
            Text("No Account History")
        } else {
            Form {
                List(user.activeProfile.accountHistory) { transaction in
                    Section {
                        HistoryItemView(transaction: transaction)
                    }
                }
            }
        }
    }
}

#Preview {
    AccountHistoryView()
}
