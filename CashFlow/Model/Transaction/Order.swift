//
//  Menu.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/26/23.
//

import Foundation

struct MenuItem: Hashable, Identifiable, Comparable, Codable {
    static func < (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.name < rhs.name
    }

    var id = UUID()
    var name: String
    var cost: Double
    var count: Int = 0

    static let exampleItems = [MenuItem(name: "Ex1", cost: 50), MenuItem(name: "Ex2", cost: 60)]
}

class Order: ObservableObject, Hashable, Codable, Identifiable {
    @Published private(set) var items = [MenuItem]()
    @Published var totalCost: Double = 0.0
    var id = UUID()
    var to = ""
    var finalCost: Double {
        var cost: Double = 0
        for item in items {
            cost += Double(item.count) * item.cost
        }
        return cost
    }

    var isEmpty: Bool {
        items.isEmpty
    }

    enum CodingKeys: CodingKey {
        case items, totalCost, id, to
    }

    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        items = try container.decode([MenuItem].self, forKey: .items)
        totalCost = try container.decode(Double.self, forKey: .totalCost)
        id = try container.decode(UUID.self, forKey: .id)
        to = try container.decode(String.self, forKey: .to)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(items, forKey: .items)
        try container.encode(totalCost, forKey: .totalCost)
        try container.encode(id, forKey: .id)
        try container.encode(to, forKey: .to)
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    func edit(_ item: MenuItem) {
        if let index = items.firstIndex(where: { $0.name == item.name }) {
            if item.count == 0 {
                items.remove(at: index)
            } else {
                items[index] = item
            }

        } else {
            if item.count > 0 {
                items.append(item)
            }
        }
        items.sort()
        calculateTotal()
    }

    func calculateTotal() {
        totalCost = 0
        for item in items {
            totalCost += Double(item.count) * item.cost
        }
    }

    func clear() {
        items = []
        calculateTotal()
    }

    func loadItems(_ providedItems: [MenuItem]) {
        items = providedItems
        calculateTotal()
    }

    static func == (lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id
    }
}
