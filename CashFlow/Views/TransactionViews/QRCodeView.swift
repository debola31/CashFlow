//
//  QRCodeView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/28/23.
//

import CombineCoreBluetooth
import SwiftUI

struct QRCodeView: View {
    @Binding var transaction: Transaction?
    @EnvironmentObject var user: User
    @EnvironmentObject var centralDevice: CentralDevice
    @StateObject var peripheralDevice = PeripheralDevice()
    @Environment(\.dismiss) var dismiss
    @ObservedObject var order: Order
    @State private var qrCode = UIImage()
    @State var scannedImage = false
//    @State var transactionComplete = false

    func loadCode() {
        CBUUID.service = CBUUID(string: UUID().uuidString)
        qrCode = centralDevice.generateQRCode(from: CBUUID.service.uuidString)
    }

    var body: some View {
//        NavigationStack {
        VStack {
            Text("Scan Invoice")
                .font(.largeTitle)
                .padding(.bottom, 40)

            Image(uiImage: qrCode)
                .interpolation(scannedImage ? .high : .none)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)

            Spacer()

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

            if let device = centralDevice.connectedPeripheral {
                QRPeripheralView(device, centralDevice, order)
            } else {
                ForEach(centralDevice.peripherals) { discovery in
                    ProgressView()
                        .onAppear {
                            centralDevice.connect(discovery)
                        }
                }
            }
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
            if let device = centralDevice.connectedPeripheral {
                centralDevice.centralManager.cancelPeripheralConnection(device)
            }
        }
        .onChange(of: peripheralDevice.response) {
            transaction = Transaction(order: order)
//            transactionComplete = true
        }
//        }
    }
}

// #Preview {
//    QRCodeView(order: Order())
// }
