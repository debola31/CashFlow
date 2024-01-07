//
//  QRPeripheralView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/30/23.
//

import CombineCoreBluetooth
import SwiftUI

struct QRPeripheralView: View {
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var bill: Bill

    init(_ peripheral: Peripheral, _ bill: Bill) {
        self.device = .init(peripheral)
        self.bill = bill

        if let data = try? JSONEncoder().encode(bill) {
            print("sent data")
            print(bill)
            device.write(
                data: data,
                to: .writeResponseCharacteristic,
                type: .withResponse,
                result: \ConnectedPeripheral.$writeResponseResult
            )
        }
    }

    var body: some View {
        ProgressView()
    }
}
