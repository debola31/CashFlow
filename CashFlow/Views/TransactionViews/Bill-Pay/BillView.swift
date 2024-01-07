//
//  OrderView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import CodeScanner
import CoreBluetooth
import CoreImage.CIFilterBuiltins
import SwiftUI

struct BillView: View {
    @EnvironmentObject var user: User
    @StateObject var bill = Bill()
    @State var isShowingScanner = false
    @State var navPath = NavigationPath()
    @State var disableTransaction = true
    @State var billPaid = false

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
                Button("Generate Invoice Code") {
                    bill.payee = Person(id: user.activeProfile.id, name: user.activeProfile.name)
                    navPath.append(bill)
                }
                .font(.title3)
                .buttonStyle(.plain)
                .padding(30)
                .background(disableTransaction ? .gray : .blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(disableTransaction)

                Section("Bill Amount") {
                    TextField("Bill Amount", value: $bill.amount, format: .currency(code: "USD"))
                        .onChange(of: bill.amount) {
                            disableTransaction = bill.amount == 0
                        }
                    HStack {
                        Text("Max:")
                        Text(user.activeProfile.availableFunds, format: .currency(code: "USD"))
                    }
                    .foregroundStyle(.secondary)
                    Button("Clear") {
                        bill.amount = 0
                    }
                }
            }
            .navigationTitle("Bill")
            .navigationDestination(for: Bill.self, destination: { _ in
                QRCodeView(bill: bill, billPaid: $billPaid)
            })
            .sheet(isPresented: $billPaid, content: {
                ReceiptView(navPath: $navPath, bill: bill)
            })
        }
    }
}
