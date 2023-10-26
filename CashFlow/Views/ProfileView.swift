//
//  ProfileView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: User

    var body: some View {
        List {
            Section("User Information") {
                HStack {
                    Text("Profile Name:")
                    Spacer()
                    Text(user.name)
                }
                HStack {
                    Text("Email:")
                    Spacer()
                    Text(user.email)
                }
                
                HStack {
                    Text("Number:")
                    Spacer()
                    Text(user.phoneNumber, format: .number)
                }
            }
            
            Section("Profile Selection") {
                Picker("Active Profile", selection: $user.activeProfile) {
                    ForEach(user.profiles) { profile in
                        Text(profile.name)
                    }
                }
            }
            
            Section("Profile Info") {
                Text("Placeholder for Profile Picker")
                Text("Add New Profile")
            }
            
            if let profile = user.activeProfile {
                Section("Bank Information") {
//                    Picker("Primary Account", selection: $user.activeProfile?.primaryAccount) {
//                        ForEach(user.activeProfile.bankAccounts) { account in
//                            Text(account.bankName)
//                        }
//                    }
                    
                    Button("Add New") {}
                }
                
                if profile.type == .business {
                    Section {
                        NavigationLink {
                            Text("Service Menu")
                        } label: {
                            Label("Service Menu", image: "menucard")
                        }
                        
                        Button("Service Menu") {}
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(User())
}
