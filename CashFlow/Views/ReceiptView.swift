//
//  ReceiptView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct ReceiptView: View {
    @Binding var navPath: NavigationPath
    let record: Record
    var body: some View {
        VStack {
            Text("here is your receipt")
            Button("Close") {
                navPath = NavigationPath()
            }
        }
    }
}

#Preview {
    ReceiptView(navPath: .constant(NavigationPath()), record: Record.example)
}
