import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var nowPlaying = SongModel()

    var body: some View {
        VStack(spacing: 6.66) {
            AlbumArtworkView()

            Text(nowPlaying.title)
                .font(.system(size: 24, weight: .bold))

            Text(nowPlaying.artist)

            PlaybackSlider(nowPlaying: nowPlaying)

            PlaybackControlsView(nowPlaying: nowPlaying)
                .frame(height: 64)
        }
    }


}

#Preview {
    ContentView()
}
