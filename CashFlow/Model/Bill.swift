//
//  Bill.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 1/2/24.
//

import Foundation

class Bill: ObservableObject, Hashable, Codable, Identifiable, Comparable {
    static func < (lhs: Bill, rhs: Bill) -> Bool {
        lhs.date > rhs.date
    }

    static func == (lhs: Bill, rhs: Bill) -> Bool {
        lhs.id == rhs.id
    }

    var id = UUID()
    var payee: Person?
    var payer: Person?
    var date = Date()
    @Published var amount: Double = 0

    enum CodingKeys: CodingKey {
        case amount, id, payee, payer, date
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        amount = try container.decode(Double.self, forKey: .amount)
        id = try container.decode(UUID.self, forKey: .id)
        payee = try container.decodeIfPresent(Person.self, forKey: .payee)
        payer = try container.decodeIfPresent(Person.self, forKey: .payer)
        date = try container.decode(Date.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(amount, forKey: .amount)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(payee, forKey: .payee)
        try container.encodeIfPresent(payer, forKey: .payer)
        try container.encode(date, forKey: .date)
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
