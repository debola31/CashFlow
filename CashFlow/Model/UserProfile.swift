//
//  UserProfile.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import Foundation

struct UserProfile: Identifiable, Hashable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.id == rhs.id
    }

    enum types: String, Hashable {
        case business, individual
    }

    var id = UUID()
    var name: String = ""
    var type: types = .individual
    var availableFunds: Double = 0
    var accountHistory: [Transaction] = []
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "yo_NG")
        return formatter
    }()

    var formatedFunds: String {
        if let funds = currencyFormatter.string(from: availableFunds as NSNumber) {
            return funds
        }
        return "0"
    }

    var bankAccounts = [BankAccount]()
    var primaryAccount: BankAccount?

    static let example = UserProfile(name: "John Doe")

    static let nilProfile = UserProfile(name: "John Doe")
    static let addNewProfile = UserProfile(name: "Add New")
}
