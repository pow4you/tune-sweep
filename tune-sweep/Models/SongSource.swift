//
//  SongSource.swift
//  tune-sweep
//
//  Created by Lea on 30.10.26.
//

import Foundation

enum SongSource: Codable, Hashable {
    case file(String)
    case library(String)
    case stream(URL)

    var playbackURL: URL? {
        switch self {
        case .file(let name):
            let docs = URL.documentsDirectory.appending(path: name)
            if FileManager.default.fileExists(atPath: docs.path) { return docs }
            return Bundle.main.url(forResource: name, withExtension: nil)
        case .stream(let url):
            return url
        case .library:
            return nil   // later
        }
    }
}
