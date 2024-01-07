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
    @State private var name = ""
    @State private var email = "customer@email.com"
    @State private var phoneNumber: Int = 0
    @State private var disableSubmit = true

    func evalSubmit() {
        if name.count > 4,
           email.contains("@"),
           email.contains(".com"),
           "\(phoneNumber)".count == 10
        {
            disableSubmit = false
        } else { disableSubmit = true }
    }

    var body: some View {
        Form {
            TextField("Enter Profile Name:", text: $name)
                .autocorrectionDisabled()

            TextField("Enter Email:", text: $email)
                .autocorrectionDisabled()
                .disabled(true)

            TextField("Enter Phone Number:", value: $phoneNumber, format: .number)
                .autocorrectionDisabled()

            Button("Create Profile") {
                let newProfile = UserProfile(name: name,
                                             email: email,
                                             phoneNumber: phoneNumber)

                if user.activeProfile == UserProfile.example {
                    user.addFirstProfile(newProfile)
                } else {
                    user.addProfile(newProfile)
                    user.setActiveProfile(newProfile)
                }
                dismiss()
            }
            .disabled(name.count < 4)
            .onChange(of: [name, email]) {
                evalSubmit()
            }.onChange(of: phoneNumber) {
                evalSubmit()
            }
        }
    }
}

#Preview {
    NewProfileView()
}
