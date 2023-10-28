//
//  ConnectedPeripheral.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import Foundation

class ConnectedPeripheral: ObservableObject {
    let peripheral: Peripheral
    init(_ peripheral: Peripheral) {
        self.peripheral = peripheral
    }

    @Published var writeResponseResult: Result<Date, Error>?

    func write(
        to id: CBUUID,
        type: CBCharacteristicWriteType,
        result: ReferenceWritableKeyPath<ConnectedPeripheral, Published<Result<Date, Error>?>.Publisher>
    ) {
        peripheral.writeValue(
            Data("Hello".utf8),
            writeType: type,
            forCharacteristic: id,
            inService: .service
        )
        .receive(on: DispatchQueue.main)
        .map { _ in Result<Date, Error>.success(Date()) }
        .catch { e in Just(Result.failure(e)) }
        .assign(to: &self[keyPath: result])
    }
}
