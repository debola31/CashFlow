//
//  DashConfirmationVIew.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/29/23.
//

import SwiftUI

struct DashConfirmationVIew: View {
    @StateObject var peripheralDevice = PeripheralDevice()
    @EnvironmentObject var centralDevice: CentralDevice
    @Environment(\.dismiss) var dismiss
    @Binding var transaction: Transaction?

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
