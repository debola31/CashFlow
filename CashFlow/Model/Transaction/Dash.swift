//
//  Dash.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/28/23.
//

import Foundation

class Dash: ObservableObject, Hashable, Codable, Identifiable {
    static func == (lhs: Dash, rhs: Dash) -> Bool {
        lhs.id == rhs.id
    }

    var id = UUID()
    var from = ""
    @Published var amount: Double = 0

    enum CodingKeys: CodingKey {
        case amount, id, from
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        amount = try container.decode(Double.self, forKey: .amount)
        id = try container.decode(UUID.self, forKey: .id)
        from = try container.decode(String.self, forKey: .from)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(amount, forKey: .amount)
        try container.encode(id, forKey: .id)
        try container.encode(from, forKey: .from)
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
