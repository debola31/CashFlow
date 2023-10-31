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
                PayView()
                    .tabItem {
                        Label("Pay", systemImage: "dollarsign")
                    }

                DashView()
                    .tabItem {
                        Label("Dash", systemImage: "arrow.up.right.square.fill")
                    }

                CollectView()
                    .tabItem {
                        Label("Collect", systemImage: "arrow.down.right.square.fill")
                    }
            } else if user.activeProfile.type == .business {
                BillView()
                    .tabItem {
                        Label("Bill", systemImage: "dollarsign")
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
