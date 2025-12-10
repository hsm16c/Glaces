import SwiftUI



struct CreateGlaceView: View {
    
    
    @StateObject var repo = StockRepository()
    
    
    @State private var container: ContainerType = .cup
    
    
    @State private var extras: Set<Extra> = []
    
    
    @State private var selections: [FlavorSelection] = []
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Flavors") {
                    ForEach(repo.parfums) { parfum in
                        FlavorSelectorRow(
                            parfum: parfum,
                            scoops: scoopsForFlavor(parfum),
                            onIncrement: { incrementScoops(parfum: parfum) },
                            onDecrement: { decrementScoops(parfum: parfum) }
                        )
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
                    Text(currentOrder.totalPrice, format: .currency(code: "EUR"))
                        .font(.headline)
                }

                Section {
                    Button("Create ice cream") {
                        createOrder()
                    }
                    .disabled(!currentOrder.isValid)
                }
            }
            .navigationTitle("Create Ice Cream")
        }
    }
}



extension CreateGlaceView {

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
        
        guard scoopsForFlavor(parfum) < 5 else { return }
        
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
        print("Order created → \(currentOrder.totalPrice) €")
    }
}



struct FlavorSelectorRow: View {
    
    let parfum: Parfum
    let scoops: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
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
            }
        }
    }
}
