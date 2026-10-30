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

    // MARK: - State

    @Published var currentSong: Song?
    @Published var playheadPosition: Double = 0
    @Published var isPlaying: Bool = false
    @Published var artwork: UIImage?          // decoded from song.artworkData

    /// Comes from the Song (read from the file at import time).
    var duration: Double { currentSong?.duration ?? 0 }

    private let player = AVPlayer()
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        // isPlaying follows the player
        player.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .map { $0 == .playing }
            .assign(to: &$isPlaying)

        // playheadPosition follows the player
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.666, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            Task { @MainActor in
                self?.playheadPosition = time.seconds
            }
        }

        // lock screen rate follows play/pause (also when iOS pauses us)
        $isPlaying
            .dropFirst()
            .sink { [weak self] playing in
                self?.updateNowPlaying(isPlaying: playing)
            }
            .store(in: &cancellables)

        UIApplication.shared.beginReceivingRemoteControlEvents()
        configureAudioSession()
        setupRemoteCommands()
    }

    // MARK: - Playing a song

    func play(_ song: Song) {
        guard let url = song.playbackURL else {
            print("Can't resolve playback URL for \(song.title)")
            return
        }
        currentSong = song
        artwork = song.artworkData.flatMap { UIImage(data: $0) }
        playheadPosition = 0
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        updateNowPlaying()
    }

    // MARK: - Controls (used by the buttons AND the lock screen)

    func resume() { player.play() }
    func pause()  { player.pause() }

    func togglePlay() {
        isPlaying ? pause() : resume()
    }

    func seek(to seconds: Double, completion: ((Bool) -> Void)? = nil) {
        playheadPosition = seconds
        player.seek(to: CMTime(seconds: seconds, preferredTimescale: 600)) { [weak self] finished in
            Task { @MainActor in
                self?.updateNowPlaying()
                completion?(finished)
            }
        }
    }

    func skip(by seconds: Double) {
        seek(to: min(max(0, playheadPosition + seconds), duration))
    }

    func restart() { seek(to: 0) }

    func next() { seek(to: duration) }   // placeholder until there is a queue
    func previous() { restart() }        // placeholder until there is a queue

    // MARK: - Lock screen: now playing info

    private func updateNowPlaying(isPlaying playing: Bool? = nil) {
        guard let song = currentSong else { return }

        var info: [String: Any] = [
            MPNowPlayingInfoPropertyMediaType: MPNowPlayingInfoMediaType.audio.rawValue,
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime().seconds,
            MPNowPlayingInfoPropertyPlaybackRate: (playing ?? isPlaying) ? 1.0 : 0.0
        ]
        if let artist = song.artist { info[MPMediaItemPropertyArtist] = artist }
        if let album = song.album { info[MPMediaItemPropertyAlbumTitle] = album }
        if let artwork { info[MPMediaItemPropertyArtwork] = Self.makeArtwork(artwork) }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    // nonisolated on purpose: iOS calls the artwork closure from a background thread
    nonisolated static func makeArtwork(_ image: UIImage) -> MPMediaItemArtwork {
        MPMediaItemArtwork(boundsSize: image.size) { _ in image }
    }

    // MARK: - Lock screen: remote commands

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
    }

    // MARK: - Audio session

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("Audio session category error: \(error)")
        }

        // setActive can block, so keep it off the main thread
        Task.detached {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Audio session activation error: \(error)")
            }
        }
    }
}
