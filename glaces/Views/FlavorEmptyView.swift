import SwiftUI
import MessageUI

struct FlavorEmptyView: View {
    
    let parfum: Parfum
    
    @State private var signature: String = "Thanks, MB"
    @State private var showMail = false
    @StateObject private var mailService = AppInjector.shared.mailService

    var body: some View {
        VStack(spacing: 24) {
            
            Text(parfum.name)
                .font(.largeTitle)
                .bold()
            
            Image(parfum.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 180)
            
            Text("\(parfum.name) flavour is empty")
                .font(.headline)
            
            TextField("Signature", text: $signature)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button("Order") {
                mailService.sendMail(
                        subject: "Order",
                        recipients: ["order@icecream.com"],
                        body: mailBody
                    )
                if mailService.state == .ready {
                        showMail = true
                    }
                }
            .buttonStyle(.borderedProminent)
            
            Button("Check all items") {
                
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Order")
        .sheet(isPresented: $showMail) {
            MailComposerSheet(controller: mailService.makeViewController())
        }

        
    }
}



extension FlavorEmptyView {
        
        var mailBody: String {
        """
        Hi,
        Please order the following:
        * \(parfum.name) icecream
        
        \(signature)
        """
        }
        private var isMailReady: Binding<Bool> {
            Binding(
                get: { mailService.state == .ready },
                set: { _ in }
            )
    }

}
