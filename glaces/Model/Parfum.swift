import Foundation


struct Parfum: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let imageName: String
    var stockMl: Int
    let mlPerScoop: Int = 50
    var availableScoops: Int {
        stockMl / mlPerScoop
    }
    var isEmpty: Bool {
        availableScoops == 0
    }
}
