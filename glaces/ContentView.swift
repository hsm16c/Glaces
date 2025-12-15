import SwiftUI

struct ContentView: View {
    var body: some View {
        CreateGlaceView(
            repo: AppInjector.shared.provideStockRepository()
            )
    }
}
