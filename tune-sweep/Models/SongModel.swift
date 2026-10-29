import Foundation
import Combine

@MainActor
final class SongModel: ObservableObject {
    @Published var title = "Title"
    @Published var artist = "Artist"
    @Published var duration: Double = 100
    @Published var playheadPosition: Double = 0
    @Published var isPlaying = false
}
