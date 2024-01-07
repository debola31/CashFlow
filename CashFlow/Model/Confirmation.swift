//
//  Confirmation.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import Foundation

struct BillConfirmation: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var invoice: Bill
}

struct Cancel: Codable, Hashable {
    var id = UUID()
    var cancel = true
    var date = Date()
}
