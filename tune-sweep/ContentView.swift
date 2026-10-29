import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var player = PlayerModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Button("Play mock") {
                player.play(Song(title: "Test", artist: "Me", duration: 180, fileName:"test.mp3" ))
            }
            
            AlbumArtworkView()

            Text(player.currentSong?.title ?? "No song selected")
                .font(.system(size: 24, weight: .bold))

            Text(player.currentSong?.artist ?? "artist")

            PlaybackSlider(nowPlaying: player)

            PlaybackControlsView(player: player)
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
