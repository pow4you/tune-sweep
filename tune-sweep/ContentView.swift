import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var player = PlayerModel()
    
    var body: some View {
        VStack(spacing: 6.66) {
            AlbumArtworkView()

            Text(player.currentSong?.title ?? "No song selected")
                .font(.system(size: 24, weight: .bold))

            Text(player.currentSong?.artist ?? "")

            PlaybackSlider(nowPlaying: player)

            PlaybackControlsView(nowPlaying: player)
                .frame(height: 64)
        }
    }
    
    private func playSong(_ song: Song) {
        player.play(song)
    }


}

#Preview {
    ContentView()
}
