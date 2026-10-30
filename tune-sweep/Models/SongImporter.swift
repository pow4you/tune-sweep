//
//  SongImporter.swift
//  tune-sweep
//
//  Created by Lea on 30.10.26.
//

import AVFoundation

@MainActor
enum SongImporter {
    static func makeSong(fileName: String) async -> Song? {
        let source = SongSource.file(fileName)
        guard let url = source.playbackURL else { return nil }

        let asset = AVURLAsset(url: url)
        let items = (try? await asset.load(.commonMetadata)) ?? []

        func tag(_ id: AVMetadataIdentifier) -> AVMetadataItem? {
            AVMetadataItem.metadataItems(from: items, filteredByIdentifier: id).first
        }

        let fallbackTitle = url.deletingPathExtension().lastPathComponent
        let title = try? await tag(.commonIdentifierTitle)?.load(.stringValue)
        let song = Song(source: source, title: title ?? fallbackTitle)

        song.artist = try? await tag(.commonIdentifierArtist)?.load(.stringValue)
        song.album = try? await tag(.commonIdentifierAlbumName)?.load(.stringValue)
        song.artworkData = try? await tag(.commonIdentifierArtwork)?.load(.dataValue)
        song.duration = (try? await asset.load(.duration))?.seconds ?? 0
        return song
    }
}



