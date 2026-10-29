import Foundation
import Combine

@MainActor
final class SongModel: ObservableObject {
    @Published var title: String = "Title"
    @Published var artist: String = "Artist"
    @Published var duration: Double = 100 // seconds
    @Published var playheadPosition: Double = 0
    @Published var isPlaying: Bool = false
}
