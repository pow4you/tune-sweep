//
//  Song.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import Foundation
import SwiftData

@Model
final class Song {
    var title: String
    var artist: String
    var duration: Double
    var playlist: Playlist?

    init(
        title: String,
        artist: String,
        duration: Double,
        playlist: Playlist? = nil
    ) {
        self.title = title
        self.artist = artist
        self.duration = duration
        self.playlist = playlist
    }
}
