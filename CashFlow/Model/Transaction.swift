//
//  Transaction.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import Foundation

struct Transaction: Hashable {
    enum types: String {
        case pay, dash, charge, collect
    }

    var amount: Double
}
