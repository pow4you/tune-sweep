# next steps, in order:
1. **Move the logic out of the views into `PlayerModel`.** Right now `PlaybackControlsView` mutates `playheadPosition` and `isPlaying` directly. Give the model methods for `next()` and `previous()`. The lock-screen commands will need to call the same functions as your buttons, so the model should be the single place where playback logic lives.
2.  **Add** the audio session, background mode, now-playing info and remote commands.

## smaller things:
- `ContentView` has an unused `playSong(_:)` and `modelContext`, and no list of songs yet, so you can't pick a track from the UI. A `@Query` over `Song` in a `List` is the SwiftData-idiomatic way once you're ready.
- The repo has no `.gitignore`, so `xcuserdata/` (including your username folder) is committed. Adding the standard Xcode/Swift `.gitignore` and running `git rm -r --cached` on those folders cleans that up.
