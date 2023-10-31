//
//  DashCodeView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/29/23.
//

import CombineCoreBluetooth
import SwiftUI

struct DashCodeView: View {
    @Binding var transaction: Transaction?
    @EnvironmentObject var dash: Dash
    @EnvironmentObject var user: User
    @EnvironmentObject var centralDevice: CentralDevice
    @StateObject var peripheralDevice = PeripheralDevice()
    @Environment(\.dismiss) var dismiss
    @State private var qrCode = UIImage()
    @State var scannedImage = false

    func loadCode() {
        CBUUID.service = CBUUID(string: UUID().uuidString)
        qrCode = centralDevice.generateQRCode(from: CBUUID.service.uuidString)
    }

    var body: some View {
        VStack {
            Text(scannedImage ? "Waiting for Confirmation" : "Scan Dash")
                .font(.title)
                .padding(.bottom, 40)

            Image(uiImage: qrCode)
                .interpolation(scannedImage ? .high : .none)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)

            Spacer()

            if let device = centralDevice.connectedPeripheral {
                if transaction == nil {
                    DashQRPeripheralView(device, dash)
                        .onAppear {
                            scannedImage = true
                        }
                }

            } else {
                ForEach(centralDevice.peripherals) { discovery in
                    ProgressView()
                        .onAppear {
                            centralDevice.connect(discovery)
                        }
                }
            }

            Button("Cancel") {
                dismiss()
            }
            .padding(20)
            .font(.title2)
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .background(.black)
            .clipShape(Capsule())
            .padding(.vertical, 20)
        }
        .onAppear {
            loadCode()
            centralDevice.searchForPeripherals()
            peripheralDevice.start()
        }
        .onDisappear {
            centralDevice.stopSearching()
            centralDevice.peripheralConnectResult = nil
            peripheralDevice.stop()
        }
        .onChange(of: peripheralDevice.receivedDashConfirmation) {
            if let confirmedDash = peripheralDevice.receivedDashConfirmation {
                if transaction == nil {
                    user.takeOutFunds(confirmedDash.dash.amount)
                    transaction = Transaction(
                        date: confirmedDash.date,
                        dash: confirmedDash.dash,
                        payer: confirmedDash.dash.from,
                        payee: confirmedDash.from,
                        type: .dash)
                }
            }
        }
    }
}
