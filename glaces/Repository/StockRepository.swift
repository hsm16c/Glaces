import Foundation


protocol StockRepository: ObservableObject {
    
    var parfums: [Parfum] { get }
    func consumeScoops(parfum: Parfum, scoops: Int)
}
