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
    @ObservedObject var order: Order

    init(_ peripheral: Peripheral, _ order: Order) {
        self.device = .init(peripheral)
        self.order = order

        if let data = try? JSONEncoder().encode(order.items) {
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
