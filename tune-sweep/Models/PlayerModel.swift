//
//  PlayerModel.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import Foundation
import Combine
import AVFoundation



@MainActor
final class PlayerModel: ObservableObject {
    @Published var currentSong: Song?
    @Published var playheadPosition: Double = 0
    @Published var isPlaying: Bool = false
    @Published var duration: Double = 0
    
    private let player = AVPlayer()
    private var timeObserver: Any?

    init() {
        // 1. isPlaying follows the player
        player.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .map { $0 == .playing }
            .assign(to: &$isPlaying)

        // 2. playheadPosition follows the player
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 666),
            queue: .main
        ) { [weak self] time in
            Task { @MainActor in
                self?.playheadPosition = time.seconds
            }
        }
    }

    func play(_ song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: nil) else { return }

        let item = AVPlayerItem(url: url)
        currentSong = song
        player.replaceCurrentItem(with: item)
        player.play()

        Task {
            if let time = try? await item.asset.load(.duration) {
                duration = time.seconds
            }
        }
    }

    func togglePlay() {
        // if isPlaying: pause the player, else play it, then update isPlaying
        if(isPlaying) {
            player.pause()
            
            isPlaying = false
        } else {
            player.play()
            
            isPlaying = true;
        }
    }

    func seek(to seconds: Double) {
        player.seek(to: CMTime(seconds: seconds, preferredTimescale: 666))
        playheadPosition = seconds
    }
}
