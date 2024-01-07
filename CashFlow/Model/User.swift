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
    var paystackToken = "Bearer sk_test_73659bcb65d63dafa8c7ad9a88face58d4aec07f"
    @Published private(set) var profiles: [UserProfile] = [UserProfile.example]
    @Published private(set) var activeProfile = UserProfile.example

    enum CodingKeys: CodingKey {
        case id, email, phoneNumber, profiles, activeProfile
    }

    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        profiles = try container.decode([UserProfile].self, forKey: .profiles)
        activeProfile = try container.decode(UserProfile.self, forKey: .activeProfile)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(profiles, forKey: .profiles)
        try container.encode(activeProfile, forKey: .activeProfile)
    }

    var hasBanks: Bool {
        !activeProfile.bankAccounts.isEmpty
    }

    func addFirstProfile(_ profile: UserProfile) {
        profiles = [profile]
        activeProfile = profile
        syncProfiles()
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

    func addBill(_ bill: Bill) {
        activeProfile.accountHistory.append(bill)
        activeProfile.accountHistory.sort()
        syncProfiles()
    }

    func removeBill(_ indexSet: IndexSet) {
        activeProfile.accountHistory.remove(atOffsets: indexSet)
        syncProfiles()
    }
}
