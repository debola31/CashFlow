//
//  PeripheralDevice.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import Foundation

class PeripheralDevice: ObservableObject {
    let peripheral: Peripheral
    init(_ peripheral: Peripheral) {
        self.peripheral = peripheral
    }

    @Published var writeResponseResult: Result<Date, Error>?
    @Published var writeNoResponseResult: Result<Date, Error>? // never should be set
    @Published var writeResponseOrNoResponseResult: Result<Date, Error>?

    func write(
        to id: CBUUID,
        type: CBCharacteristicWriteType,
        result: ReferenceWritableKeyPath<PeripheralDevice, Published<Result<Date, Error>?>.Publisher>
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

    func writeWithoutResponse(to id: CBUUID) {
        writeNoResponseResult = nil

        peripheral.writeValue(
            Data("Hello".utf8),
            writeType: .withoutResponse,
            forCharacteristic: id,
            inService: .service
        )
        .receive(on: DispatchQueue.main)
        .map { _ in Result<Date, Error>.success(Date()) }
        .catch { e in Just(Result.failure(e)) }
        .assign(to: &$writeNoResponseResult)
    }
}
