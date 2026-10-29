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
    var fileName: String
    var playlist: Playlist?

    init(
        title: String,
        artist: String,
        duration: Double,
        fileName: String,
        playlist: Playlist? = nil
    ) {
        self.title = title
        self.artist = artist
        self.duration = duration
        self.fileName = fileName
        self.playlist = playlist
    }
}
