//
//  PaymentView.swift
//  CashFlow
//
//  Created by ADEBOLA AKEREDOLU on 1/5/24.
//
import SafariServices
import SwiftUI

struct PaymentView: View {
    let url: URL
    @Binding var isShowing: Bool
    var body: some View {
        SafariView(url: url)
            .onAppear {
                isShowing = true
            }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

#Preview {
    PaymentView(url: URL(string: "https://checkout.paystack.com/tzny77ehkhonc00")!, isShowing: .constant(false))
}
