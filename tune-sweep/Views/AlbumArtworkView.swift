//
//  AlbumArtworkView.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import SwiftUI

struct AlbumArtworkView: View {
    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .containerRelativeFrame(.horizontal) { length, _ in
                length * 0.62
            }
            .overlay {
                Image(.cover)
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .gray, radius: 6.66)
    }
}

#Preview {
    AlbumArtworkView()
}
