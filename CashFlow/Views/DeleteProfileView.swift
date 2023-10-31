//
//  DeleteProfileView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import SwiftUI

struct DeleteProfileView: View {
    @EnvironmentObject var user: User
    var body: some View {
        Form {
            Section("Profiles") {
                ForEach(user.profiles) { profile in
                    if profile.id != user.activeProfile.id {
                        Text(profile.name)
                    }

                }.onDelete { indexSet in
                    user.deleteProfile(indexSet)
                }
            }
        }.toolbar {
            EditButton()
        }
    }
}

#Preview {
    DeleteProfileView()
}
