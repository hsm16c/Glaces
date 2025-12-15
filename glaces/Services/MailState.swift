enum MailState: Equatable {
    case idle
    case ready
    case notAvailable
    case sent
    case error(message: String)
}
