import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var rotation: Double = 0

    var body: some View {
        if isActive {
            ContentView() // ak je uvodna obrazovka skoncena, zobrazi sa main obrazovka
        } else {
            VStack {
                Image("Image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(rotation))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
                Text("EASYTODO™")
                    .font(.largeTitle)
            }
            .onAppear {
                rotation = 360
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
