//
//  CancellingView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 1/6/24.
//

import SwiftUI

struct FinishCancelling: View {
    @ObservedObject var device: ConnectedPeripheral
    init(_ device: ConnectedPeripheral) {
        self.device = device
        let cancel = Cancel()

        if let data = try? JSONEncoder().encode(cancel) {
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
