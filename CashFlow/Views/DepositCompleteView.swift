//
//  DepositCompleteView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 1/4/24.
//

import SwiftUI

struct DepositCompleteView: View {
    let amount: Double
    @Binding var navPath: NavigationPath
    var body: some View {
        Text("Deposit of \(amount) complete")
        Image(systemName: "checkmark.circle")
        Button("Done") {
            navPath = NavigationPath()
        }
    }
}

#Preview {
    DepositCompleteView(amount: 0, navPath: .constant(NavigationPath()))
}
