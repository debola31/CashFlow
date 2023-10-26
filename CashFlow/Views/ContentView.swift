//
//  ContentView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var user = User(activeProfile: UserProfile.example)
    var body: some View {
        NavigationStack {
            if let profile = user.activeProfile {
                TabView {
                    SummaryView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }

                    if profile.type == .individual {
                        TransactionView(transactionType: .pay)
                            .tabItem {
                                Label("Pay", systemImage: "dollarsign")
                            }

                        TransactionView(transactionType: .dash)
                            .tabItem {
                                Label("Dash", systemImage: "arrow.up.right.square.fill")
                            }
                    } else if profile.type == .business {
                        TransactionView(transactionType: .charge)
                            .tabItem {
                                Label("Charge", systemImage: "dollarsign")
                            }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            ProfileView()
                        } label: {
                            Label("User", systemImage: "person.circle")
                        }
                    }
                }
            } else {
                Form {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Label("Create New User", systemImage: "person.circle")
                    }
                }
            }
        }
        .environmentObject(user)
    }
}

#Preview {
    ContentView()
}
