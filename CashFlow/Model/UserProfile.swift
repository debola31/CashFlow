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

    var id = UUID()
    var name: String = ""
    var email: String = "customer@email.com"
    var phoneNumber: Int = 1234567890
    var availableFunds: Double = 0
    var accountHistory: [Bill] = []

    var bankAccounts = [BankAccount]()
    var primaryAccount: BankAccount?

    static let saveKey = "CashFlow"
    static let example = UserProfile(name: "John Doe's")
}

struct Person: Identifiable, Codable, Hashable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }

    let id: UUID
    let name: String
}
