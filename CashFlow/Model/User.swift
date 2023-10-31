//
//  User.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import SwiftUI

class User: ObservableObject, Codable {
    let saveKey = "CashFlow"
    var id = UUID()
    var email: String = "example@example.com"
    var phoneNumber: Int = 1234567890
    @Published private(set) var profiles: [UserProfile] = [UserProfile.example]
    @Published private(set) var activeProfile = UserProfile.example

    enum CodingKeys: CodingKey {
        case id, email, phoneNumber, profiles, activeProfile
    }

    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        phoneNumber = try container.decode(Int.self, forKey: .phoneNumber)
        profiles = try container.decode([UserProfile].self, forKey: .profiles)
        activeProfile = try container.decode(UserProfile.self, forKey: .activeProfile)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(profiles, forKey: .profiles)
        try container.encode(activeProfile, forKey: .activeProfile)
    }

    var hasBanks: Bool {
        !activeProfile.bankAccounts.isEmpty
    }

    func addProfile(_ profile: UserProfile) {
        profiles.append(profile)
        syncProfiles()
    }

    func deleteProfile(_ indexSet: IndexSet) {
        profiles.remove(atOffsets: indexSet)
        syncProfiles()
    }

    func setActiveProfile(_ profile: UserProfile) {
        activeProfile = profile
        syncProfiles()
    }

    func syncProfiles() {
        if let index = profiles.firstIndex(where: { $0.id == activeProfile.id }) {
            profiles[index] = activeProfile
        }
        save()
    }

    func addBank(_ bank: BankAccount) {
        activeProfile.bankAccounts.append(bank)
        syncProfiles()
    }

    func setPrimaryBank(_ bank: BankAccount) {
        activeProfile.primaryAccount = bank
        syncProfiles()
    }

    func addMenuItem(_ item: MenuItem) {
        activeProfile.menuItems.append(item)
        activeProfile.menuItems.sort()
        syncProfiles()
    }

    func removeMenuItem(_ indexSet: IndexSet) {
        activeProfile.menuItems.remove(atOffsets: indexSet)
        syncProfiles()
    }

    func addFunds(_ funds: Double) {
        activeProfile.availableFunds += funds
        syncProfiles()
    }

    func takeOutFunds(_ funds: Double) {
        activeProfile.availableFunds -= funds
        syncProfiles()
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: UserProfile.saveKey)
        }
    }

    func addTransaction(_ transaction: Transaction) {
        activeProfile.accountHistory.append(transaction)
        activeProfile.accountHistory.sort()
        syncProfiles()
    }

    func removeTransaction(_ indexSet: IndexSet) {
        activeProfile.accountHistory.remove(atOffsets: indexSet)
        syncProfiles()
    }
}
