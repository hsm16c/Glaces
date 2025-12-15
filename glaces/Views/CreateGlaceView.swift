import SwiftUI



struct CreateGlaceView: View {
    
    @StateObject var repo: StockRepositoryDummyImpl
    @State private var container: ContainerType = .cup
    @State private var extras: Set<Extra> = []
    @State private var selections: [FlavorSelection] = []
    @State private var lastOrderPrice: Double = 0.0
    
    @State private var selectedEmptyParfum: Parfum? = nil
    @State private var showFlavorEmptyView = false
    @State private var showOrderAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                
                
                Section {
                    ForEach(repo.parfums) { parfum in
                        FlavorSelectorRow(
                            parfum: parfum,
                            scoops: scoopsForFlavor(parfum),
                            onIncrement: { incrementScoops(parfum: parfum) },
                            onDecrement: { decrementScoops(parfum: parfum) },
                            onEmptyTapped: {
                                    selectedEmptyParfum = parfum
                                    showFlavorEmptyView = true
                                }
                        )
                    }
                } header: {
                    HStack {
                        Text("Scoops flavours")
                        
                        Spacer()
                        
                        if let errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }
                
                
                Section("Container") {
                    Picker("Container", selection: $container) {
                        ForEach(ContainerType.allCases) { type in
                            Text(type.label).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                
                Section("Extras") {
                    ForEach(Extra.allCases) { extra in
                        Toggle(extra.label, isOn: Binding(
                            get: { extras.contains(extra) },
                            set: { isOn in
                                if isOn { extras.insert(extra) }
                                else { extras.remove(extra) }
                            }
                        ))
                    }
                }
                
                
                Section("Price") {
                    Text("\(currentOrder.totalPrice, format: .currency(code: "EUR"))")
                        .font(.headline)
                }
                
                
                Section {
                    Button("Create ice cream") {
                        createOrder()      // $ CHANGE
                    }
                    .disabled(!currentOrder.isValid)
                }
                
            }
            .navigationTitle("Create Ice Cream")
            
            .navigationDestination(isPresented: $showFlavorEmptyView) {
                if let parfum = selectedEmptyParfum {
                    FlavorEmptyView(parfum: parfum)
                }
            }

            
            .alert("Ice cream created", isPresented: $showOrderAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Total: \(lastOrderPrice, format: .currency(code: "EUR"))")
            }
        }
    }
}



extension CreateGlaceView {
    
    
    var errorMessage: String? {
        if currentOrder.totalScoops > 5 {
            return "too many scoops selected"
        }
        return nil
    }
    
    
    var currentOrder: GlacesOrder {
        GlacesOrder(
            parfums: selections,
            container: container,
            extras: extras
        )
    }
    
    
    func scoopsForFlavor(_ parfum: Parfum) -> Int {
        selections.first(where: { $0.parfum == parfum })?.scoops ?? 0
    }
    
    
    func incrementScoops(parfum: Parfum) {
        let currentScoops = scoopsForFlavor(parfum)
        let totalScoops = currentOrder.totalScoops
        
        guard scoopsForFlavor(parfum) < 5 else { return }
        guard totalScoops < 5 else { return }
        guard scoopsForFlavor(parfum) < parfum.availableScoops else { return }
        
        if let index = selections.firstIndex(where: { $0.parfum == parfum }) {
            selections[index].scoops += 1
        } else {
            selections.append(FlavorSelection(parfum: parfum, scoops: 1))
        }
    }
    
    
    func decrementScoops(parfum: Parfum) {
        guard let index = selections.firstIndex(where: { $0.parfum == parfum }) else { return }
        
        selections[index].scoops -= 1
        
        if selections[index].scoops <= 0 {
            selections.remove(at: index)
        }
    }
    
    
    func createOrder() {
        lastOrderPrice = currentOrder.totalPrice
        for selection in selections {
                    repo.consumeScoops(parfum: selection.parfum, scoops: selection.scoops)
                }
        showOrderAlert = true
        selections = []
                extras = []
                container = .cup
    }
}


struct FlavorSelectorRow: View {
    
    let parfum: Parfum
    let scoops: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onEmptyTapped: () -> Void
    
    var body: some View {
        HStack {
            
            Image(parfum.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(parfum.name)
                    .font(.headline)
                
                if parfum.isEmpty {
                    Text("Out of stock")
                        .foregroundColor(.red)
                        .font(.caption)
                } else {
                    Text("\(parfum.availableScoops) scoops available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack {
                Button("-") { onDecrement() }
                    .buttonStyle(.bordered)
                
                Text("\(scoops)")
                    .frame(width: 30)
                
                Button("+") { onIncrement() }
                    .buttonStyle(.bordered)
                    .disabled(parfum.isEmpty || scoops >= parfum.availableScoops)
                
                
                if parfum.isEmpty {
                    Button{
                        onEmptyTapped()
                    }label: {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    
                }
            }
        }
    }
}
