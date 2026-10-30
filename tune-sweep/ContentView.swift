import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var player = PlayerModel()
    
    @Query private var songs: [Song]
    
    var body: some View {
        VStack(spacing: 24) {
            Button("Play mock") {
                let source = SongSource.file("test.mp3")
                if let existing = songs.first(where: { $0.source == source }) {
                    player.play(existing)
                } else {
                    Task {
                        if let song = await SongImporter.makeSong(fileName: "test.mp3") {
                            modelContext.insert(song)
                            player.play(song)
                        }
                    }
                }
            }
            
            AlbumArtworkView(image: player.artwork)

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
