//
//  Paystack.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 1/5/24.
//

import Foundation

struct InitiationRequest: Codable {
    var email: String
    var amount: String
}

struct InitiationData: Codable {
    var authorization_url: URL
    var access_code: String
    var reference: String
}

struct TransactionInitiation: Codable {
    var status: Bool
    var message: String
    var data: InitiationData
}

struct PaystackCharge: Identifiable {
    var id = UUID()
    var url: URL
}

struct VerificationData: Codable {
    var id: Int
    var reference: String
    var status: String
}

struct TransactionVerification: Codable {
    var data: VerificationData
}

struct WithdrawalData: Codable {
    var amount: Double
    var reason = "Customer Withdrawal"
    var recipient = "RCP_5tw7zt8bsnoz73c"
}

struct Withdrawal: Codable {
    var source = "balance"
    var transfers: [WithdrawalData]
}

struct WithdrawalResponseData: Codable {
    var reference: String
    var recipient: String
    var amount: Double
    var transfer_code: String
    var currency: String
    var status: String
}

struct WithdrawalResponse: Codable {
    var status: Bool
    var message: String
    var data: [WithdrawalResponseData]
}

struct PaystackWithdrawal: Identifiable {
    var id = UUID()
    var amout: Double
}
