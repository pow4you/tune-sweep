//
//  PlaybackSlider.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import SwiftUI

struct PlaybackSlider: View {
    @ObservedObject var nowPlaying: SongModel

    var body: some View {
        Slider(
            value: $nowPlaying.playheadPosition,
            in: 0...max(nowPlaying.duration, 1),
            step: 0.666
        ) {
            Text("Playback position")
        } minimumValueLabel: {
            Text(
                Duration.seconds(nowPlaying.playheadPosition)
                    .formatted(.time(pattern: .minuteSecond))
            )
        } maximumValueLabel: {
            Text(
                Duration.seconds(nowPlaying.duration)
                    .formatted(.time(pattern: .minuteSecond))
            )
        }
        .containerRelativeFrame(.horizontal) { length, _ in
            length * 0.81
        }
    }
}

#Preview {
    PlaybackSlider(nowPlaying: SongModel())
        .padding()
}
