//
//  PlayerModel.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import Foundation
import Combine

@MainActor
final class PlayerModel: ObservableObject {
    @Published var currentSong: Song?
    @Published var playheadPosition: Double = 0
    @Published var isPlaying: Bool = false

    func play(_ song: Song) {
        currentSong = song
        playheadPosition = 0
        isPlaying = true
    }
}
