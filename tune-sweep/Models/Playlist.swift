//
//  Playlist.swift
//  tune-sweep
//
//  Created by Lea on 29.10.26.
//

import Foundation
import SwiftData

@Model
final class Playlist {
    var name: String

    @Relationship(deleteRule: .cascade, inverse: \Song.playlist)
    var songs: [Song] = []

    init(name: String, songs: [Song] = []) {
        self.name = name
        self.songs = songs
    }
}
