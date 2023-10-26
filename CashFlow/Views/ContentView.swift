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
        TabView {
            if let profile = user.activeProfile {
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

                    TransactionView(transactionType: .collect)
                        .tabItem {
                            Label("Collect", systemImage: "hands.sparkles.fill")
                        }
                } else if profile.type == .business {
                    TransactionView(transactionType: .charge)
                        .tabItem {
                            Label("Charge", systemImage: "dollarsign")
                        }

                    TransactionView(transactionType: .refund)
                        .tabItem {
                            Label("Charge", systemImage: "dollarsign.arrow.circlepath")
                        }
                }
            } else {
                ProfileView()
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
        .environmentObject(user)
    }
}

// struct ContentView: View {
//    @State private var presentedNumbers = [Int]()
//
//    var body: some View {
//        NavigationStack(path: $presentedNumbers) {
//            List(1..<50) { i in
//                NavigationLink(value: i) {
//                    Label("Row \(i)", systemImage: "\(i).circle")
//                }
//            }
//            .navigationDestination(for: Int.self) { i in
//                VStack {
//                    Text("Detail \(i)")
//
//                    Button("Go to Next") {
//                        presentedNumbers.append(i + 1)
//                    }
//                }
//            }
//            .navigationTitle("Navigation")
//        }
//    }
// }

#Preview {
    ContentView()
}
