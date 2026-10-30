//
//  Song.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import Foundation
import UIKit
import AVFoundation
import SwiftData
import MediaPlayer


@Model
final class Song {
    var source: SongSource
    var title: String
    var artist: String?
    var album: String?
    var albumArtist: String?
    var genre: String?
    var trackNumber: Int?
    var discNumber: Int?
    var releaseDate: Date?
    var duration: Double?                 // nil = live stream
    @Attribute(.externalStorage) var artworkData: Data?
    var artworkURL: URL?                  // remote artwork (streams, thumbnails)
    var originURL: URL?                   // where a download came from (yt-dlp)
    var addedAt: Date = Date()

    var isLive: Bool { duration == nil }
    var displayArtist: String { artist ?? "Unknown Artist" }

    init(source: SongSource, title: String) {
        self.source = source
        self.title = title
    }
    
    var playbackURL: URL? { source.playbackURL }
    
    var playlist: Playlist?
}
