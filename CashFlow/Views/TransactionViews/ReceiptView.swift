//
//  ReceiptView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct ReceiptView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var centralDevice: CentralDevice
    @Environment(\.dismiss) var dismiss
    @Binding var navPath: NavigationPath
    @ObservedObject var bill: Bill
    var body: some View {
        NavigationStack {
            Form {
                Section("Transaction Details") {
                    HistoryItemView(bill: bill)
                }

                Button("Close") {
                    navPath = NavigationPath()
                    dismiss()
                }
            }
            .navigationTitle("Payment Receipt")
            .onAppear {
                user.addBill(bill)
            }
            .onDisappear {
                centralDevice.stopSearching()
                centralDevice.peripheralConnectResult = nil
            }
        }
    }
}
