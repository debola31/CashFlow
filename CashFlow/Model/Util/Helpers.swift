//
//  Helpers.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 1/4/24.
//

import Foundation

extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0.count > 0 {
                    return $0 + " " + String($1)
                }
            }
            return $0 + String($1)
        }
    }
}
