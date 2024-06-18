//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/18.
//

import MessageUI
import SwiftUI
import UIKit

public struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentation

    private var address: [String]
    private var subject: String
    private var body: String

    public init(address: [String], subject: String, body: String) {
        self.address = address
        self.subject = subject
        self.body = body
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients(address)
        viewController.setSubject(subject)
        viewController.setMessageBody(body, isHTML: false)

        return viewController
    }

    public func updateUIViewController(_: MFMailComposeViewController, context _: UIViewControllerRepresentableContext<MailView>) {
    }
}

extension MailView {
    public class Coordinator: NSObject {
        @Binding private var presentation: PresentationMode

        init(presentation: Binding<PresentationMode>) {
            _presentation = presentation
        }
    }
}

extension MailView.Coordinator: MFMailComposeViewControllerDelegate {
    public func mailComposeController(
        _: MFMailComposeViewController,
        didFinishWith _: MFMailComposeResult,
        error _: Error?
    ) {
        $presentation.wrappedValue.dismiss()
    }
}

extension MailView {
    public static func canSendMail() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
}

