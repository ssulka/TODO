// MenuView.swift
import SwiftUI



struct MenuView: View {
    @State var isSettingsOpen = false
    @Environment(\.dismiss) private var dismiss
    @State private var isAboutOpen = false
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Button(action: { dismiss() }) {
                
                Text("Zavrieť")
                    .foregroundColor(.blue)
                    .font(.headline)
                    .padding(.top,30)
                    .padding(.horizontal,20)
                Spacer()
            }
            Text("Menu")
                .font(.largeTitle)
                .fontWeight(.bold)
                
                
            List {
                Button(action: {}) {
                    Label("Všetky zoznamy úloh", systemImage: "list.bullet")
                    
                }
                    Button(action: {isSettingsOpen=true}) {
                        Label("Nastavenia", systemImage: "gear")
                    }.sheet(isPresented: $isSettingsOpen) {
                        Settings()}
                    
                    Button(action: {isAboutOpen=true}) {
                        Label("O aplikácii", systemImage: "info.circle")
                        
                    }.sheet(isPresented: $isAboutOpen) {
                        About()    }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.1))
        }
        
    }
        
}
#Preview {
    MenuView()
}
