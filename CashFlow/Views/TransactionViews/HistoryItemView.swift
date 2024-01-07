//
//  HistoryItemView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import SwiftUI

struct HistoryItemView: View {
    let bill: Bill
    var body: some View {
        Section {
            HStack {
                Text("Date:")
                Spacer()
                Text(bill.date, format: .dateTime)
            }

            HStack {
                Text("Reference #:")
                Spacer()
                Text(bill.id.uuidString.prefix(13))
            }

            HStack {
                Text("Amount:")
                Spacer()
                Text(bill.amount, format: .currency(code: "USD"))
            }

            HStack {
                Text("From:")
                Spacer()
                Text(bill.payer?.name ?? "")
            }

            HStack {
                Text("To:")
                Spacer()
                Text(bill.payee?.name ?? "")
            }
        }
    }
}

#Preview {
    HistoryItemView(bill: Bill())
}
