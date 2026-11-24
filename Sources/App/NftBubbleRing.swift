import SwiftUI
import Foundation

struct NftBubbleRing: View {
    let size: CGFloat

    private let thumbs: [String] = [
        "5472026645659401564-photo-m.bin",
        "5384510480775669175-photo-m.bin",
        "5201966171603106893-photo-m.bin",
        "5255975823436973213-photo-m.bin",
        "5294459769791210746-photo-m.bin",
        "5452055425690123301-photo-m.bin"
    ]

    @State private var animate = false

    private func offset(for index: Int, animated: Bool) -> CGSize {
        let angle = Double(index) / Double(thumbs.count) * 2.0 * .pi + (animated ? 0.22 : -0.22)
        let radius = Double(size) * 0.60
        return CGSize(
            width: CGFloat(cos(angle) * radius),
            height: CGFloat(sin(angle) * radius)
        )
    }

    var body: some View {
        ZStack {
            ForEach(Array(thumbs.enumerated()), id: \.offset) { pair in
                ThumbView(name: pair.element)
                    .frame(width: size * 0.27, height: size * 0.27)
                    .background(Circle().fill(Color(.systemBackground)))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.18), radius: 3, x: 0, y: 2)
                    .offset(offset(for: pair.offset, animated: animate))
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
