import Foundation


enum ContainerType: String, CaseIterable, Identifiable {
    case cup
    case cone
    
    var id: Self { self }
    
    
    var label: String {
        switch self {
        case .cup:  return "Cup"
        case .cone: return "Cone"
        }
    }
    
    
    var extraPrice: Double {
        switch self {
        case .cup:  return 0.0
        case .cone: return 1.0
        }
    }
}


enum Extra: String, CaseIterable, Identifiable {
    case creme_chantilly
    case noisettes
    
    var id: Self { self }
    
    
    var label: String {
        switch self {
        case .creme_chantilly: return "Whipped cream"
        case .noisettes:  return "Hazelnuts"
        }
    }
    
    
    var price: Double {
        
        return 0.95
    }
}
