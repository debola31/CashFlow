//
//  Transaction.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import Foundation

struct Transaction: Hashable, Codable, Identifiable, Comparable {
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.date > rhs.date
    }

    enum types: String, Codable {
        case dash, charge

        var actionText: String {
            switch self {
            case .dash:
                return "Generate Dash Code"
            case .charge:
                return "Generate Invoice Code"
            }
        }
    }

    var date = Date()
    var id = UUID()
    var order: Order?
    var dash: Dash?
    var payer: String?
    var payee: String?
    var type: types

    static let example = Transaction(type: .dash)
}
