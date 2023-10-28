//
//  ConnectedPeripheralView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import SwiftUI

struct ConnectedPeripheralView: View {
    @ObservedObject var device: PeripheralDevice
    @ObservedObject var central: CentralDevice

    init(_ peripheral: Peripheral, _ central: CentralDevice) {
        self.device = .init(peripheral)
        self.central = central
    }

    var body: some View {
        Section("Characteristic sends response") {
            Button("Write with response") {
                if device.peripheral.state == .disconnected {
                    print("disconnected")
                } else {
                    device.write(
                        to: .writeResponseCharacteristic,
                        type: .withResponse,
                        result: \PeripheralDevice.$writeResponseResult
                    )
                }
            }
        }
    }

    func label<T>(for result: Result<T, Error>?) -> some View {
        Group {
            switch result {
            case let .success(value)?:
                Text("Wrote at \(String(describing: value))")
            case let .failure(error)?:
                if let error = error as? LocalizedError, let errorDescription = error.errorDescription {
                    Text("Error: \(errorDescription)")
                } else {
                    Text("Error: \(String(describing: error))")
                }
            case nil:
                EmptyView()
            }
        }
    }
}

// #Preview {
//    ConnectedPeripheralView()
// }
