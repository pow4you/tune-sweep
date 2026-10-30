//
//  AlbumArtworkView.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import SwiftUI

struct AlbumArtworkView: View {
    let image: UIImage?

    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .containerRelativeFrame(.horizontal) { length, _ in
                length * 0.62
            }
            .overlay {
                Image(uiImage: image ?? .defaultCover)
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .gray, radius: 6.66)
    }
}

#Preview {
    AlbumArtworkView(image: nil)
        .padding()
}
