//
//  QRCodeView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/28/23.
//

import CombineCoreBluetooth
import SwiftUI

struct QRCodeView: View {
    @ObservedObject var bill: Bill
    @EnvironmentObject var user: User
    @EnvironmentObject var centralDevice: CentralDevice
    @StateObject var peripheralDevice = PeripheralDevice()
    @Environment(\.dismiss) var dismiss
    @State private var qrCode = UIImage()
    @State var scannedImage = false
    @Binding var billPaid: Bool

    func loadCode() {
        CBUUID.service = CBUUID(string: UUID().uuidString)
        qrCode = centralDevice.generateQRCode(from: CBUUID.service.uuidString)
    }

    var body: some View {
        VStack {
            Text(scannedImage ? "Waiting for Confirmation" : "Scan Bill")
                .font(.title)
                .padding(.bottom, 40)

            Image(uiImage: qrCode)
                .interpolation(scannedImage ? .high : .none)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)

            Spacer()

            if let device = centralDevice.connectedPeripheral {
                if bill.payer == nil {
                    QRPeripheralView(device, bill)
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
        .onChange(of: peripheralDevice.receivedBillConfirmation) {
            if let confirmedBill = peripheralDevice.receivedBillConfirmation {
                if bill.payer == nil {
                    user.addFunds(confirmedBill.invoice.amount)
                    bill.payer = confirmedBill.invoice.payer
                    billPaid = true
                }
            }
        }
        .onChange(of: peripheralDevice.receivedCancel) {
            if let _ = peripheralDevice.receivedCancel {
                dismiss()
            }
        }
    }
}
