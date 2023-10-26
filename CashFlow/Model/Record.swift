//
//  Record.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import Foundation

struct Record: Hashable, Identifiable {
    var transaction: Transaction
    var date = Date()
    var id = UUID()

    static let example = Record(transaction: Transaction.example)
}
