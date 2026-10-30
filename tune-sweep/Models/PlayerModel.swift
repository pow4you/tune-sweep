//
//  PlayerModel.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import Foundation
import Combine
import AVFoundation
import MediaPlayer
import UIKit

@MainActor
final class PlayerModel: ObservableObject {
    @Published var currentSong: Song?
    @Published var playheadPosition: Double = 0
    @Published var isPlaying: Bool = false
    @Published var duration: Double = 0
    
    private let player = AVPlayer()
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    
    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
        } catch {
            print("Audio session category error: \(error)")
        }

        Task.detached {
            do {
                try session.setActive(true)
            } catch {
                print("Audio session activation error: \(error)")
            }
            print("audio session active")
        }
    }
    
    private func updateNowPlaying(isPlaying playing: Bool? = nil) {
        print("updateNowPlaying called, song: \(currentSong?.title ?? "nil"), playing: \(isPlaying)")

        guard let song = currentSong else { return }
        let rate = (playing ?? isPlaying) ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPNowPlayingInfoPropertyMediaType: MPNowPlayingInfoMediaType.audio.rawValue,
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime().seconds,
            MPNowPlayingInfoPropertyPlaybackRate: rate
        ]
        
        MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
        
        print("nowPlayingInfo:", MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:])
        
    }
    
    private func setupRemoteCommands() {
        let cc = MPRemoteCommandCenter.shared()

        cc.playCommand.isEnabled = true
        cc.playCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.resume() }
            return .success
        }

        cc.pauseCommand.isEnabled = true
        cc.pauseCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.pause() }
            return .success
        }

        cc.togglePlayPauseCommand.isEnabled = true
        cc.togglePlayPauseCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.togglePlay() }
            return .success
        }

        cc.nextTrackCommand.isEnabled = true
        cc.nextTrackCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.next() }
            return .success
        }

        cc.previousTrackCommand.isEnabled = true
        cc.previousTrackCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.previous() }
            return .success
        }

        cc.changePlaybackPositionCommand.isEnabled = true
        cc.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            let position = event.positionTime
            Task { @MainActor in self?.seek(to: position) }
            return .success
        }
        print("remote commands registered")

    }
    
    init() {
        // 1. isPlaying follows the player
        player.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .map { $0 == .playing }
            .assign(to: &$isPlaying)

        // 2. playheadPosition follows the player
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.666, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            Task { @MainActor in
                self?.playheadPosition = time.seconds
            }
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        setupRemoteCommands()
        
        configureAudioSession()
        
        $isPlaying
            .dropFirst()
            .sink { [weak self] playing in
                self?.updateNowPlaying(isPlaying: playing)
            }
            .store(in: &cancellables)
        
        
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
    
    
    
    
    
    

    func resume() { player.play() }
    func pause()  { player.pause() }

    func togglePlay() {
        isPlaying ? pause() : resume()
    }

    
    
    func seek(to seconds: Double, completion: ((Bool) -> Void)? = nil) {
        player.seek(to: CMTime(seconds: seconds, preferredTimescale: 666)){ finished in
            Task { @MainActor in
                completion?(finished)
            }
        }
        playheadPosition = seconds
    }

    func skip(by seconds: Double) {
        seek(to: min(max(0, playheadPosition + seconds), duration))
    }

    func restart() { seek(to: 0) }

    func next() { seek(to: duration) }   // placeholder until you have a queue
    func previous() { restart() }        // same
}
