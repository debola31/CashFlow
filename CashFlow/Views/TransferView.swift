//
//  TransferView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct TransferView: View {
    var mode: Transfer.Mode
    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss
    @State var transferAmount: Double = 0
    @State private var bankSelection = 0
    @State private var transferViewShowing = false
    @State private var initiatingTransfer = false
    @State private var charge: PaystackCharge?
    @State private var chargeReference: String?
    @State private var withdrawal: PaystackWithdrawal?
    @State private var withdrawalAmount: Double?
    var maxTransfer: Double {
        let maxDeposit: Double = 10_000_000
        if mode == .deposit {
            return maxDeposit - user.activeProfile.availableFunds
        } else {
            return user.activeProfile.availableFunds
        }
    }

    func initiateTransaction(for amount: Double) async {
        let url = URL(string: "https://api.paystack.co/transaction/initialize")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(user.paystackToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        let initiationRequest = InitiationRequest(email: user.activeProfile.email, amount: "\(transferAmount)")
        guard let encoded = try? JSONEncoder().encode(initiationRequest) else {
            print("Failed to encode order")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decoded = try JSONDecoder().decode(TransactionInitiation.self, from: data)
            chargeReference = decoded.data.reference
            charge = PaystackCharge(url: decoded.data.authorization_url)

        } catch {
            print("Checkout failed: \(error.localizedDescription)")
        }
    }

    func validateTransaction(for reference: String) async -> Bool {
        guard let url = URL(string: "https://api.paystack.co/transaction/verify/\(reference)") else { return false }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(user.paystackToken, forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(TransactionVerification.self, from: data)
            if decoded.data.status == "success" {
                return true
            }
        } catch {
            print("Invalid data")
        }
        return false
    }

    var body: some View {
        Group {
            if transferViewShowing {
                ProgressView()
            } else {
                Form {
                    Section("Enter \(mode.rawValue.capitalized) Amount") {
                        TextField("Enter Amount", value: $transferAmount, format: .currency(code: "USD"))
                            .font(.headline)
                            .padding(.bottom, 5)
                        HStack {
                            Text("Max:")
                            Text(maxTransfer, format: .currency(code: "USD"))
                        }
                        HStack {
                            Text("Min:")
                            Text(10_000, format: .currency(code: "USD"))
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 5)
                    }

                    Button {
                        if mode == .deposit {
                            Task {
                                initiatingTransfer = true
                                await initiateTransaction(for: transferAmount)
                                initiatingTransfer = false
                            }
                        } else if mode == .withdrawal {
                            initiatingTransfer = true
                            withdrawal = PaystackWithdrawal(amout: transferAmount)
                            withdrawalAmount = transferAmount
                            initiatingTransfer = false
                        }
                    } label: {
                        HStack {
                            Text("Initiate \(mode.rawValue.capitalized)")
                            Spacer()
                            if initiatingTransfer {
                                ProgressView()
                            }
                        }
                    }
                }
                .navigationTitle(mode.rawValue.capitalized)
            }
        }
        .sheet(item: $charge) {
            Task {
                if let reference = chargeReference {
                    let chargeResult = await validateTransaction(for: reference)
                    if chargeResult { user.addFunds(transferAmount) }
                }
                dismiss()
            }

        } content: { charge in
            PaymentView(url: charge.url, isShowing: $transferViewShowing)
        }
        .sheet(item: $withdrawal) {
            if let withdrawalAmount = withdrawalAmount {
                user.takeOutFunds(withdrawalAmount)
            }
            dismiss()

        } content: { withdrawal in
            WithdrawalView(amount: withdrawal.amout, isShowing: $transferViewShowing)
        }
    }
}

#Preview {
    TransferView(mode: .deposit)
        .environmentObject(User())
}
