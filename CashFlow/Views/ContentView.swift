//
//  ContentView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var user: User
    @StateObject var centralDevice = CentralDevice()
    @State var profileChange = false

    init() {
        if let data = UserDefaults.standard.data(forKey: UserProfile.saveKey) {
            if let decoded = try? JSONDecoder().decode(User.self, from: data) {
                _user = StateObject(wrappedValue: decoded)
                return
            }
        }
        _user = StateObject(wrappedValue: User())
    }

    var body: some View {
        TabView {
            SummaryView(profileChange: $profileChange)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            if user.activeProfile.type == .individual {
                TransactionView(transactionType: .pay)
                    .tabItem {
                        Label("Pay", systemImage: "dollarsign")
                    }

                TransactionView(transactionType: .dash)
                    .tabItem {
                        Label("Dash", systemImage: "arrow.up.right.square.fill")
                    }

                TransactionView(transactionType: .collect)
                    .tabItem {
                        Label("Collect", systemImage: "hands.sparkles.fill")
                    }
            } else if user.activeProfile.type == .business {
                TransactionView(transactionType: .charge)
                    .tabItem {
                        Label("Charge", systemImage: "dollarsign")
                    }

                TransactionView(transactionType: .refund)
                    .tabItem {
                        Label("Refund", systemImage: "dollarsign.arrow.circlepath")
                    }
            }
        }
        .id(user.activeProfile.type)
        .environmentObject(user)
        .environmentObject(centralDevice)
        .sheet(isPresented: $profileChange) {
            ProfileView(profileChange: $profileChange)
                .environmentObject(user)
        }
    }
}

#Preview {
    ContentView()
}
