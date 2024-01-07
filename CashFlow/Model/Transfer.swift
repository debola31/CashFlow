//
//  Transfer.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import Foundation

struct Transfer: Identifiable {
    enum Mode: String {
        case deposit, withdrawal
    }

    var id = UUID()
    var mode: Mode
    var amount: Double = 0
    static let example = Transfer(mode: .deposit)
}
