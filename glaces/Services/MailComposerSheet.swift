import SwiftUI
import MessageUI

struct MailComposerSheet: UIViewControllerRepresentable {
    let controller: MFMailComposeViewController

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) { }
}
