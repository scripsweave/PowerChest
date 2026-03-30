import SwiftUI

struct ConfettiOverlay: View {
    private struct Seed: Identifiable {
        let id = UUID()
        let xPosition: CGFloat
        let endOffsetX: CGFloat
        let endOffsetY: CGFloat
        let size: CGFloat
        let color: Color
        let delay: Double
        let duration: Double
        let rotation: Double
    }

    private let seeds: [Seed] = ConfettiOverlay.makeSeeds()
    @State private var animate = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(seeds) { seed in
                    Capsule()
                        .fill(seed.color)
                        .frame(width: seed.size, height: seed.size * 2)
                        .rotationEffect(.degrees(animate ? seed.rotation : 0))
                        .position(x: proxy.size.width * seed.xPosition,
                                  y: proxy.size.height * 0.05)
                        .offset(x: animate ? seed.endOffsetX : 0,
                                y: animate ? seed.endOffsetY : 0)
                        .opacity(animate ? 0 : 1)
                        .animation(
                            .easeInOut(duration: seed.duration)
                                .delay(seed.delay),
                            value: animate
                        )
                }
            }
        }
        .onAppear {
            animate = true
        }
        .allowsHitTesting(false)
    }

    private static func makeSeeds() -> [Seed] {
        let palette: [Color] = [.pink, .orange, .yellow, .green, .mint, .blue, .purple]
        return (0..<18).map { _ in
            Seed(
                xPosition: CGFloat.random(in: 0.1...0.9),
                endOffsetX: CGFloat.random(in: -120...120),
                endOffsetY: CGFloat.random(in: 100...220),
                size: CGFloat.random(in: 4...8),
                color: palette.randomElement() ?? .pink,
                delay: Double.random(in: 0...0.15),
                duration: Double.random(in: 0.8...1.3),
                rotation: Double.random(in: 120...520)
            )
        }
    }
}
