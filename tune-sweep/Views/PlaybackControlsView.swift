//
//  PlaybackControlsView.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import SwiftUI

struct PlaybackControlsView: View {
    @ObservedObject var player: PlayerModel

    var body: some View {
        HStack {
            Button {
                replaySong()
            } label: {
                Image(systemName: "backward.end.fill")
                    .frame(width: 36)
                    .font(.system(size: 28))
            }

            Button {
                backwardSong()
            } label: {
                Image(systemName: "backward.fill")
                    .imageScale(.large)
            }

            Button {
                togglePlaySong()
            } label: {
                Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                    .frame(width: 64)
                    .font(.system(size: 36))
            }

            Button {
                forwardSong()
            } label: {
                Image(systemName: "forward.fill")
                    .imageScale(.large)
            }

            Button {
                skipSong()
            } label: {
                Image(systemName: "forward.end.fill")
                    .frame(width: 36)
                    .font(.system(size: 28))
            }
        }
    }

    private func replaySong() {
        player.seek(to: 0)
    }

    private func backwardSong() {
        player.seek(to: max(0, player.playheadPosition - 5))
    }

    private func togglePlaySong() {
        player.togglePlay()
    }

    private func forwardSong() {
        player.seek(to: min(player.duration, player.playheadPosition + 5))
    }

    private func skipSong() {
        player.seek(to: player.duration)
    }
}

#Preview {
    PlaybackControlsView(player: PlayerModel())
        .padding()
}
