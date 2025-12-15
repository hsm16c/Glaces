import Foundation

protocol MailService: ObservableObject {
    var state: MailState { get }
    func sendMail(subject: String, recipients: [String], body: String)
}
