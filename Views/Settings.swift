import SwiftUI


    struct Settings: View {
        @Environment(\.dismiss) private var dismiss
        @AppStorage("colorScheme") private var colorScheme = 0
        @Environment(\.colorScheme) private var systemColorScheme
        @EnvironmentObject private var appearanceSettings: AppearanceSettings
        
        var body: some View {
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Zavrieť")
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

