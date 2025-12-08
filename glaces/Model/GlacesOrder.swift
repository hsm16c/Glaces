import Foundation

struct FlavorSelection: Identifiable {
    let id: UUID = UUID()
    let parfum: Parfum
    var scoops: Int
}

struct IceCreamOrder {
    var parfums: [FlavorSelection]
    var container: ContainerType
    var extras: Set<Extra>
    var totalScoops: Int {
        parfums.reduce(0) { $0 + $1.scoops }
    }
    var isValid: Bool {
        guard totalScoops > 0, totalScoops <= 5 else {
            return false
        }
        
        for selection in parfums {
            if selection.scoops > selection.parfum.availableScoops {
                return false
            }
        }
        
        return true
    }
    
    private var scoopsPrice: Double {
        switch totalScoops {
        case 1: return 1.50
        case 2: return 3.00
        case 3: return 4.00
        case 4: return 5.00
        case 5: return 5.50
        default: return 0.0
        }
    }

    private var extrasPrice: Double {
        Double(extras.count) * 0.95
    }
    
    var totalPrice: Double {
        scoopsPrice + container.extraPrice + extrasPrice
    }
}
