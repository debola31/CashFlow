//
//  PayView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import SwiftUI

import CodeScanner
import CoreBluetooth
import SwiftUI

struct PayView: View {
    @EnvironmentObject var user: User
    @State var isShowingScanner = false
    @State var navPath = NavigationPath()
    @State var disableTransaction = false
    @State var bill: Bill?

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            // Set Bluetooth Service String
            CBUUID.service = CBUUID(string: result.string)
            navPath.append(Bill())

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            Form {
                Button("Scan Invoice") {
                    isShowingScanner = true
                }
                .font(.title3)
                .buttonStyle(.plain)
                .padding(30)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Pay")
            .navigationDestination(for: Bill.self) { _ in
                ConfirmationView(bill: $bill)
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
            .sheet(item: $bill) { bill in
                ReceiptView(navPath: $navPath, bill: bill)
            }
        }
    }
}
