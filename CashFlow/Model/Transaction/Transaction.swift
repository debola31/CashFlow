//
//  Transaction.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import Foundation

struct Transaction: Hashable {
    enum types: String {
        case pay, dash, charge, collect, refund
    }

    let date = Date()
    var id = UUID()
    var order: Order?

    static let example = Transaction()
}
