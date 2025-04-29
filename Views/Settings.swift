import SwiftUI


    struct Settings: View {
        @Environment(\.dismiss) private var dismiss
        @AppStorage("colorScheme") private var colorScheme = 0
        @Environment(\.colorScheme) private var systemColorScheme
        @EnvironmentObject private var appearanceSettings: AppearanceSettings
        @AppStorage("backgroundColorHex") private var backgroundColorHex: String = "#0000FF" // default modrá
        
        var body: some View {
            

            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Exit")
                            .foregroundColor(.blue)
                            .font(.headline)
                    }
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 30)
                
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Background color")
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack(spacing: 10) {
                        colorCircle("#1E90FF") // Modrá
                        colorCircle("#FF6347") // Červená
                        colorCircle("#32CD32") // Zelená
                        colorCircle("#000000") // Cierna
                        colorCircle("#FF69B4") // Rúžová
                        colorCircle("#8A2BE2") // Modrofialová
                        colorCircle("#FF4500") // Oranžová
                        colorCircle("#00CED1") // Tyrkysová
        
                       
                        
                        
                        
                        
                        
                        
                        
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Display settings")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        displayModeButton(title: "System mode", mode: 0)
                        displayModeButton(title: "Light mode", mode: 1)
                        displayModeButton(title: "Dark mode", mode: 2)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .preferredColorScheme(getPreferredColorScheme())
        }
        
        private func displayModeButton(title: String, mode: Int) -> some View {
            Button(action: {
                colorScheme = mode
            }) {
                HStack {
                    Text(title)
                        .font(.title3)
                    
                    Spacer()
                    
                    if colorScheme == mode {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        
        private func colorCircle(_ hex: String) -> some View {
            Button(action: {
                backgroundColorHex = hex
            }) {
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(backgroundColorHex == hex ? Color.black : Color.clear, lineWidth: 2)
                    )
            }
        }

        private func getPreferredColorScheme() -> ColorScheme? {
            switch colorScheme {
            case 1:
                return .light
            case 2:
                return .dark
            default:
                return nil // System setting
            }
        }
    }
    
    #Preview {
        Settings()
    }

