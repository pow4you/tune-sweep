//
//  PlaybackSlider.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import SwiftUI

struct PlaybackSlider: View {
    @ObservedObject var nowPlaying: PlayerModel
    
    
    @State private var isScrubbing = false
    @State private var scrubPosition: Double = 0
    
    private var shownPosition: Double {
        isScrubbing ? scrubPosition : nowPlaying.playheadPosition
    }

    var body: some View {
        Slider(
            value: Binding(
                get: { shownPosition },
                set: { scrubPosition = $0 }
            ),
            in: 0...max(nowPlaying.duration, 1),
            step: 0.666
        ) {
            Text("Playback position")
        } minimumValueLabel: {
            Text(
                Duration.seconds(shownPosition)
                    .formatted(.time(pattern: .minuteSecond))
            )
        } maximumValueLabel: {
            Text(
                Duration.seconds(nowPlaying.duration)
                    .formatted(.time(pattern: .minuteSecond))
            )
        } onEditingChanged: { editing in
            if editing {
                scrubPosition = nowPlaying.playheadPosition
                isScrubbing = true
            } else {
                nowPlaying.seek(to: scrubPosition) { finished in
                    if finished { isScrubbing = false }
                }
                
            }
        }
        .containerRelativeFrame(.horizontal) { length, _ in
            length * 0.81
        }
    }
}

#Preview {
    PlaybackSlider(nowPlaying: PlayerModel())
        .padding()
}
