//
//  Transfer.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import Foundation

struct Transfer: Identifiable {
    enum Types: String {
        case deposit, withdrawal
    }

    var id = UUID()
    var type: Types
    var amount: Double = 0
    static let maxDeposit: Double = 100_000
    static let example = Transfer(type: .deposit)
}
