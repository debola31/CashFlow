//
//  TransactionView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import CodeScanner
import SwiftUI

struct TransactionView: View {
    let transactionType: Transaction.types
    @EnvironmentObject var user: User
    @State var isShowingScanner = false
    @State var navPath = NavigationPath()
    var actionText: String {
        switch transactionType {
        case .pay:
            return "Scan Invoice Code"
        case .dash:
            return "Generate Dash Code"
        case .collect:
            return "Scan Dash Code"
        case .charge:
            return "Generate Service Items"
        case .refund:
            return "Scan Refunde Code"
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            print(result)
            print("success")
            navPath.append(Transaction.example)
//            let details = result.string.components(separatedBy: "\n")
//            guard details.count == 2 else { return }
//
//            let person = Prospect()
//            person.name = details[0]
//            person.emailAddress = details[1]
//
//            prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
                Button(actionText) {
                    isShowingScanner = true
                }
                .buttonStyle(.plain)
                .padding(30)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)

                Section("Account Summary") {
                    Text("Funds: \(user.activeProfile?.availableFunds ?? 0)")
                }

                Section("Transaction History") {
                    Text("Transactions")
                }
            }
            .navigationDestination(for: Transaction.self) { transaction in
                ConfirmationView(navPath: $navPath, transaction: transaction)
            }
            .navigationDestination(for: Record.self, destination: { record in
                ReceiptView(navPath: $navPath, record: record)
            })
            .navigationTitle(transactionType.rawValue.capitalized)
            .sheet(isPresented: $isShowingScanner) {
                let randomInt = Int.random(in: 1 ... 1000)
                CodeScannerView(codeTypes: [.qr], simulatedData: "\(randomInt) Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
        }
    }
}

#Preview {
    TransactionView(transactionType: .pay)
        .environmentObject(User())
}
