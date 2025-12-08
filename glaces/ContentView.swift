import SwiftUI

struct ContentView: View {
    @StateObject var repo = StockRepository()
    
    var body: some View {
        List(repo.parfums) { parfum in
            HStack {
                Text(parfum.name)
                Spacer()
                Text("\(parfum.availableScoops) scoops")
            }
        }
    }
}
