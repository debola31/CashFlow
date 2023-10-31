//
//  Bluetooth.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 10/27/23.
//

import CombineCoreBluetooth
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

extension CBUUID {
//    static let service = CBUUID(string: "1337")
    static let writeResponseCharacteristic = CBUUID(string: "0001")
    static var service = CBUUID(string: UUID().uuidString)
}

class CentralDevice: ObservableObject {
    let centralManager: CentralManager = .live()
    @Published var peripherals: [PeripheralDiscovery] = []
    var scanTask: AnyCancellable?
    @Published var peripheralConnectResult: Result<Peripheral, Error>?
    @Published var scanning: Bool = false

    var connectedPeripheral: Peripheral? {
        guard case let .success(value) = peripheralConnectResult else { return nil }
        return value
    }

    var connectError: Error? {
        guard case let .failure(value) = peripheralConnectResult else { return nil }
        return value
    }

    func searchForPeripherals() {
        scanTask = centralManager.scanForPeripherals(withServices: [CBUUID.service])
            .scan([]) { list, discovery -> [PeripheralDiscovery] in
                guard !list.contains(where: { $0.id == discovery.id }) else { return list }
                return list + [discovery]
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.peripherals = $0
            })
        scanning = centralManager.isScanning
    }

    func stopSearching() {
        scanTask = nil
        peripherals = []
        scanning = centralManager.isScanning
    }

    func connect(_ discovery: PeripheralDiscovery) {
        centralManager.connect(discovery.peripheral)
            .map(Result.success)
            .catch { Just(Result.failure($0)) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$peripheralConnectResult)
    }

    func directConnect(_ peripheral: Peripheral) {
        centralManager.connect(peripheral)
            .map(Result.success)
            .catch { Just(Result.failure($0)) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$peripheralConnectResult)
    }

    // For QR Code generation
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
