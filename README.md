#  Tune Sweep

A music player for iOS, written in SwiftUI. My first Swift project.

The long-term idea: a small, no-nonsense player that can also pull whole playlists from YouTube, SoundCloud, Bandcamp and other platforms into a local library, using [yt-dlp](https://github.com/yt-dlp/yt-dlp) through [PythonKit](https://github.com/pvieito/PythonKit).

> **Status: early work in progress.** The player works with a bundled test song. Everything below under *Roadmap* is not built yet.

## What works today

- Playback through `AVPlayer`, driven by a single `PlayerModel`
- Playback state (playing / paused, playhead position, duration) mirrors the actual player
- Custom controls: play/pause, ±5 s skip, restart, skip to end
- Scrubbing slider with elapsed and total time
- SwiftData models for `Song` and `Playlist`

## Roadmap

- [x] Lock-screen and Control Center controls (audio session, now-playing info, remote commands)
- [x] Background playback
- [ ] Song list and playlist views backed by SwiftData
- [ ] Queue, next / previous, shuffle
- [ ] Local library: import audio files, read title / artist / duration from the file
- [ ] Python runtime + yt-dlp on device via PythonKit
- [ ] Download single tracks, then whole playlists (Bandcamp and SoundCloud first)
- [ ] Background downloads

## Architecture

```
ContentView ── owns ──► PlayerModel (ObservableObject, owns the AVPlayer)
   ├─ AlbumArtworkView
   ├─ PlaybackSlider          reads state, calls seek(to:)
   └─ PlaybackControlsView    reads state, calls togglePlay(), skip(by:), ...
```

- **Views stay dumb.** They display state and call methods; they contain no playback logic.
- **`PlayerModel` is the single place for playback logic**, so the UI and the lock-screen commands call exactly the same functions.
- **`Song` stores facts about a file** (title, artist, file name). The live player state (position, duration, playing) comes from `AVPlayer`, not from the database.
- Songs store a *relative* file name and resolve it at play time, because an app container's absolute path can change between launches.

## Getting started

Requirements: a recent Xcode, iOS 17 or later (SwiftData).

1. Clone the repo and open `tune-sweep.xcodeproj`.
2. Add an audio file to the project (tick *Add to target*) and match its name in the mock song.
3. Pick a simulator and run.

To test lock-screen controls you need a real device:

1. In *Signing & Capabilities*, choose your own team and change the bundle identifier to something unique.
2. Enable *Background Modes → Audio, AirPlay, and Picture in Picture*.
3. Run on your iPhone. With a free Apple ID the install expires after 7 days; just run again from Xcode.

## Notes

- This is a personal project meant to run on my own device. It is not built with App Store distribution in mind, especially once the downloader exists.
- Only download content you have the rights to, and respect the terms of the platforms you use.

## Planned stack

Swift, SwiftUI, SwiftData, AVFoundation, MediaPlayer, PythonKit (later: a bundled Python runtime and yt-dlp).

## License

Not decided yet.
