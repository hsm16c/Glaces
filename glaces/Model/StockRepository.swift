import Foundation


final class StockRepository: ObservableObject {
    
    @Published var parfums: [Parfum] = []
    
    init() {
        loadInitialStock()
    }
    
    private func loadInitialStock() {
        self.parfums = [
            Parfum(name: "Vanilla",    imageName: "vanilla",    stockMl: 500),
            Parfum(name: "Chocolate",  imageName: "chocolate",  stockMl: 500),
            Parfum(name: "Pistachio",  imageName: "pistachio",  stockMl: 500)
        ]
    }
    
    
    func consumeScoops(parfum: Parfum, scoops: Int) {
        guard scoops > 0 else { return }
        guard let index = parfums.firstIndex(of: parfum) else { return }
        
        let mlToConsume = scoops * parfum.mlPerScoop
        parfums[index].stockMl = max(parfums[index].stockMl - mlToConsume, 0)
    }
}
