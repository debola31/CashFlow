//
//  Model.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import Foundation

extension Double {
    var inNaira: String {
//        let currencyFormatter: NumberFormatter = {
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .currency
//            formatter.locale = Locale(identifier: "yo_NG")
//            return formatter
//        }()

        return "₦ \(self)"
    }
}

struct MenuItem {}

struct MenuAddOn {}

struct Receipt {}
