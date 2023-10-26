//
//  ConfirmationView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct ConfirmationView: View {
    @Binding var navPath: NavigationPath
    var transaction: Transaction
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button("Slide to Confirm") {
                navPath = NavigationPath()
            }
            Button("View Receipt") {
                let record = Record(transaction: transaction)
                navPath.append(record)
            }
        }
    }
}

#Preview {
    ConfirmationView(navPath: .constant(NavigationPath()), transaction: Transaction.example)
}
