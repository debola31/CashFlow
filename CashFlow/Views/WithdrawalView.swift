//
//  WithdrawalView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 1/6/24.
//

import SwiftUI

struct WithdrawalView: View {
    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss
    let amount: Double
    @State private var withdrawalComplete = false
    @State private var disableWithdrawal = true
    @State private var withdrawalInProgress = false
    @Binding var isShowing: Bool

    func initiateWithdrawal(_ amount: Double) async -> Bool {
        guard let url = URL(string: "https://api.paystack.co/transfer/bulk") else { return false }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(user.paystackToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        let withdrawalData = WithdrawalData(amount: amount)
        let withdrawal = Withdrawal(transfers: [withdrawalData])

        guard let encoded = try? JSONEncoder().encode(withdrawal) else {
            print("Failed to encode withdrawal")
            return false
        }

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            let decoded = try JSONDecoder().decode(WithdrawalResponse.self, from: data)
            if let response = decoded.data.first {
                if response.status == "success" {
                    return true
                }
            }

        } catch {
            print("Checkout failed: \(error.localizedDescription)")
        }
        return false
    }

    var body: some View {
        NavigationStack {
            VStack {
                if withdrawalComplete {
                    Text("Withdrawal of \(amount) complete")
                    Image(systemName: "checkmark.circle")
                    Button("Done") {
                        dismiss()
                    }
                } else {
                    Text("Enter OTP Code")
                    OTPView(activeIndicatorColor: .blue, inactiveIndicatorColor: .black, length: 4) { value in
                        disableWithdrawal = "\(value)".count != 4
                    }
                    Button {
                        Task {
                            withdrawalInProgress = true
                            withdrawalComplete = await initiateWithdrawal(amount)
                            withdrawalInProgress = false
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Comlete Withdrawal")
                            Spacer()
                            if withdrawalInProgress {
                                ProgressView()
                            }
                        }
                    }.disabled(disableWithdrawal || withdrawalInProgress)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Exit") {
                        dismiss()
                    }.padding(5)
                }
            }.onAppear {
                isShowing = true
            }
        }
    }
}

#Preview {
    WithdrawalView(amount: 0, isShowing: .constant(true))
}
