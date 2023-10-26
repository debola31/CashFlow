//
//  User.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import Foundation

class User: ObservableObject {
    var id = UUID()
    var name: String = "John Doe"
    var email: String = "example@example.com"
    var phoneNumber: Int = 1234567890
    @Published var profiles: [UserProfile] = []
    @Published var activeProfile: UserProfile?

    init(id: UUID = UUID(), activeProfile: UserProfile? = nil) {
        self.activeProfile = activeProfile
    }
}
