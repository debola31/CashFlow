//
//  UserProfile.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import Foundation

struct UserProfile: Identifiable, Hashable, Codable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.id == rhs.id
    }

    enum Types: String, Hashable, CaseIterable, Codable {
        case business, individual
    }

    var id = UUID()
    var name: String = ""
    var type: Types = .individual
    var availableFunds: Double = 0
    var accountHistory: [Transaction] = []

    var bankAccounts = [BankAccount]()
    var primaryAccount: BankAccount?
    var menuItems = [MenuItem]()

    static let saveKey = "CashFlow"
    static let example = UserProfile(name: "John Doe's", menuItems: MenuItem.exampleItems)
}
