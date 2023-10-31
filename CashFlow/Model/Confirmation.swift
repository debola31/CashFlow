//
//  Confirmation.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import Foundation

struct DashConfirmation: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var from: String
    var dash: Dash
}

struct OrderConfirmation: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var from: String
    var order: Order
}
