//
//  PlaybackControlsView.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import SwiftUI

struct PlaybackControlsView: View {
    @ObservedObject var nowPlaying: SongModel

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
                Image(systemName: nowPlaying.isPlaying ? "pause.fill" : "play.fill")
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
        nowPlaying.playheadPosition = 0
    }

    private func backwardSong() {
        nowPlaying.playheadPosition = max(0, nowPlaying.playheadPosition - 5)
    }

    private func togglePlaySong() {
        nowPlaying.isPlaying.toggle()
    }

    private func forwardSong() {
        nowPlaying.playheadPosition = min(
            nowPlaying.duration,
            nowPlaying.playheadPosition + 5
        )
    }

    private func skipSong() {
        nowPlaying.playheadPosition = nowPlaying.duration
    }
}

#Preview {
    PlaybackControlsView(nowPlaying: SongModel())
        .padding()
}
