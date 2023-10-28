//
//  Menu.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/26/23.
//

import Foundation

struct MenuItem: Hashable, Identifiable, Comparable {
    static func < (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.name < rhs.name
    }

    var id = UUID()
    var name: String
    var cost: Double
    var count: Int = 0

    static let exampleItems = [MenuItem(name: "Ex1", cost: 50), MenuItem(name: "Ex2", cost: 60)]
}

class Order: ObservableObject {
    @Published private(set) var items = [MenuItem]()
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

        items.sort()
    }

    func clear() {
        items = []
    }
}
