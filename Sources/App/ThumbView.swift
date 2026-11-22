import SwiftUI

struct ThumbView: View {
    let name: String

    private var image: UIImage? {
        let candidates = [
            Bundle.main.url(forResource: name, withExtension: nil, subdirectory: "NftThumbs"),
            Bundle.main.url(forResource: name, withExtension: nil)
        ]
        for url in candidates.compactMap({ $0 }) {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "gift.fill")
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
