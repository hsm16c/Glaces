import Foundation

final class StockRepositoryDummyImpl: StockRepository {
    
    @Published var parfums: [Parfum] = []
    
    init() {
        loadInitialStock()
    }
    
    private func loadInitialStock() {
        parfums = [
            Parfum(name: "Vanilla", imageName: "vanilla", stockMl: 500),
            Parfum(name: "Chocolate", imageName: "chocolate", stockMl: 500),
            Parfum(name: "Pistachio", imageName: "pistachio", stockMl: 500)
        ]
    }
    
    func consumeScoops(parfum: Parfum, scoops: Int) {
        guard let index = parfums.firstIndex(of: parfum) else { return }
        let mlToConsume = scoops * parfum.mlPerScoop
        parfums[index].stockMl = max(parfums[index].stockMl - mlToConsume, 0)
    }
}
