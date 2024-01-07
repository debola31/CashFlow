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
        if user.activeProfile == UserProfile.example {
            NavigationStack {
                NavigationLink("Create Profile") {
                    NewProfileView()
                        .navigationTitle("New Profile")
                        .environmentObject(user)
                }
            }

        } else {
            TabView {
                SummaryView(profileChange: $profileChange)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                BillView()
                    .tabItem {
                        Label("Bill", systemImage: "qrcode.viewfinder")
                    }

                PayView()
                    .tabItem {
                        Label("Pay", systemImage: "paperplane")
                    }
            }
            .environmentObject(user)
            .environmentObject(centralDevice)
            .sheet(isPresented: $profileChange) {
                ProfileView(profileChange: $profileChange)
                    .environmentObject(user)
            }
        }
    }
}

#Preview {
    ContentView()
}
