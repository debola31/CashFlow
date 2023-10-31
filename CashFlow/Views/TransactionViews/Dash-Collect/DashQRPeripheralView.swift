//
//  DashQRPeripheralView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/29/23.
//

import CombineCoreBluetooth
import SwiftUI

struct DashQRPeripheralView: View {
    @ObservedObject var device: ConnectedPeripheral
    @ObservedObject var dash: Dash

    init(_ peripheral: Peripheral, _ dash: Dash) {
        self.device = .init(peripheral)
        self.dash = dash

        if let data = try? JSONEncoder().encode(dash) {
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
