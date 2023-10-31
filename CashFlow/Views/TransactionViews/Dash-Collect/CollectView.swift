//
//  CollectView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/29/23.
//

import CodeScanner
import CoreBluetooth
import SwiftUI

struct CollectView: View {
    @EnvironmentObject var user: User
    @State var isShowingScanner = false
    @State var navPath = NavigationPath()
    @State var transaction: Transaction?
    @StateObject var dash = Dash()

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            // Set Bluetooth Service String
            CBUUID.service = CBUUID(string: result.string)
            navPath.append(dash)

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
                Button("Scan Dash Code") {
                    isShowingScanner = true
                }
                .font(.title3)
                .buttonStyle(.plain)
                .padding(30)
                .background(.brown)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Collect")
            .navigationDestination(for: Dash.self) { _ in
                CollectConfirmationView(transaction: $transaction)
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
            .sheet(item: $transaction) { transaction in
                ReceiptView(navPath: $navPath, transaction: transaction)
            }
        }
    }
}
