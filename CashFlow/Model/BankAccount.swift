//
//  BankAccount.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import Foundation

struct BankAccount: Hashable, Identifiable, Codable {
    var id = UUID()
    var bankName: String

    static let example = BankAccount(bankName: "Sterling")
}
