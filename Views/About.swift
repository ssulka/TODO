import SwiftUI

struct About: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment:.center, spacing: 10) {
            Button(action: { dismiss() }) {
                
                Text("Exit")
                    .foregroundColor(.blue)
                    .font(.headline)
                    .padding(.top,30)
                    .padding(.horizontal,30)
                Spacer()
            }
            
            VStack {
                Text("About EasyTodo™")
                    .font(.title)
                    .fontWeight(.bold)
            }
            VStack {
                Image("IKONKA")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 300)
                Spacer()
            }
            .padding()
        }
    }
}
#Preview {
    About()
}
