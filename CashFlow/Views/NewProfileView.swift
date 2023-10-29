//
//  NewProfileView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/25/23.
//

import SwiftUI

struct NewProfileView: View {
    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss
    @State private var profileType: UserProfile.Types = .individual
    @State private var name = ""
    var body: some View {
        Form {
            Picker("Select Profile Type", selection: $profileType) {
                ForEach(UserProfile.Types.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized)
                }
            }

            TextField("Enter Profile Name:", text: $name)
                .autocorrectionDisabled()

            Button("Create Profile") {
                let newProfile = UserProfile(name: name, type: profileType)
                user.addProfile(newProfile)
                user.setActiveProfile(newProfile)
                dismiss()
            }.disabled(name.count < 4)
        }
    }
}

#Preview {
    NewProfileView()
}
