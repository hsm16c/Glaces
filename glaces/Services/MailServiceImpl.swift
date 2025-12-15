import Foundation
import MessageUI

final class MailServiceImpl: NSObject, MailService {
    
    @Published var state: MailState = .idle
    
    private var subject = ""
    private var recipients: [String] = []
    private var body = ""
    
    func sendMail(subject: String, recipients: [String], body: String) {
        guard MFMailComposeViewController.canSendMail() else {
            state = .notAvailable
            return
        }
        
        self.subject = subject
        self.recipients = recipients
        self.body = body
        state = .ready
    }
    
    func makeViewController() -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.setSubject(subject)
        controller.setToRecipients(recipients)
        controller.setMessageBody(body, isHTML: false)
        controller.mailComposeDelegate = self
        return controller
    }
}

extension MailServiceImpl: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        if let error {
            state = .error(message: error.localizedDescription)
        } else {
            state = .sent
        }
        controller.dismiss(animated: true)
    }
}
