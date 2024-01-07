//
//  OTPView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 1/4/24.
//

import SwiftUI

struct OTPView: View {
    private var activeIndicatorColor: Color
    private var inactiveIndicatorColor: Color
    private let doSomething: (String) -> Void
    private let length: Int

    @State private var otpText = ""
    @FocusState private var isKeyboardShowing: Bool

    public init(activeIndicatorColor: Color, inactiveIndicatorColor: Color, length: Int, doSomething: @escaping (String) -> Void) {
        self.activeIndicatorColor = activeIndicatorColor
        self.inactiveIndicatorColor = inactiveIndicatorColor
        self.length = length
        self.doSomething = doSomething
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ... self.length - 1, id: \.self) { index in
                self.OTPTextBox(index)
            }
        }.background(content: {
            TextField("", text: self.$otpText.limit(4))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused(self.$isKeyboardShowing)
                .onChange(of: self.otpText) {
                    self.doSomething(self.otpText)
                }
                .onAppear {
                    DispatchQueue.main.async {
                        self.isKeyboardShowing = true
                    }
                }
        })
        .contentShape(Rectangle())
        .onTapGesture {
            self.isKeyboardShowing = true
        }
    }

    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if self.otpText.count > index {
                let startIndex = self.otpText.startIndex
                let charIndex = self.otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text(" ")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            let status = (isKeyboardShowing && self.otpText.count == index)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? self.activeIndicatorColor : self.inactiveIndicatorColor)
                .animation(.easeInOut(duration: 0.2), value: status)
        }
        .padding()
    }
}

extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

#Preview {
    OTPView(activeIndicatorColor: Color.black, inactiveIndicatorColor: Color.gray, length: 4, doSomething: { _ in

    })
    .padding()
}
