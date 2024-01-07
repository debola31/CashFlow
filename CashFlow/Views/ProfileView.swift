//
//  ProfileView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: User
    @State private var profileSelection = 0
    @State private var isShowingBankSheet = false
    @Binding var profileChange: Bool
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile Selection") {
                    Picker("Active Profile", selection: $profileSelection) {
                        ForEach(user.profiles.indices, id: \.self) { selection in
                            if selection < user.profiles.count {
                                Text(user.profiles[selection].name)
                            }
                        }
                    }.onAppear {
                        if let activeIndex = user.profiles.firstIndex(where: { $0.id == user.activeProfile.id }) {
                            profileSelection = activeIndex
                        }
                    }.onChange(of: profileSelection) {
                        if profileSelection < user.profiles.count {
                            user.setActiveProfile(user.profiles[profileSelection])
                        }
                    }
                }

                Section {
                    NavigationLink("Add New Profile") {
                        NewProfileView()
                            .navigationTitle("New Profile")
                    }
                    NavigationLink("Delete Profiles") {
                        DeleteProfileView()
                            .navigationTitle("Delete Profiles")
                    }
                }

                Section("Bank Account") {
                    ForEach(user.activeProfile.bankAccounts) { bank in
                        HStack {
                            Text(bank.bankName)
                            Spacer()
                            if user.activeProfile.primaryAccount == bank {
                                Text("(Primary)")
                            }
                        }.onTapGesture {
                            user.setPrimaryBank(bank)
                        }
                    }

                    Button("Add Bank") {
                        isShowingBankSheet = true
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $isShowingBankSheet) {
                NewBankView()
            }
            .toolbar {
                ToolbarItem {
                    Button("Exit") {
                        profileChange = false
                    }.padding(5)
                }
            }
        }
    }
}

#Preview {
    ProfileView(profileChange: .constant(false))
        .environmentObject(User())
}
