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

class Order: ObservableObject, Equatable, Hashable {
    static func == (lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    var id = UUID()
    @Published private(set) var items = [MenuItem]()
    @Published var totalCost: Double = 0.0
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
        calculateTotal()
        items.sort()
    }

    func calculateTotal() {
        totalCost = 0
        for item in items {
            totalCost += Double(item.count) * item.cost
        }
    }

    func clear() {
        items = []
    }

    func loadItems(_ providedItems: [MenuItem]) {
        items = providedItems
    }
}
