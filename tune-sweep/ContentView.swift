//
//  ContentView.swift
//  tune-sweep
//
//  Created by Lea on 27.10.26.
//

import SwiftUI
import SwiftData
public import Combine

class SongModel: ObservableObject {
    @Published var name: String = "Name";
    @Published var title: String = "Title";
    @Published var artist: String = "Artist";
    @Published var duration: Double = 100; //seconds.milliseconds
    

}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var isPlaying = false
    @StateObject private var nowPlaying = SongModel()
    
    @State private var playheadPosition: Double = 0 //seconds.milliseconds

    var body: some View {
        VStack(spacing: 6.66){
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length * 0.62
                    }
                    .overlay {
                        Image(.cover)
                            .resizable()
                            .scaledToFill()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .gray, radius: 6.66)

                                    
                Text(nowPlaying.title)
                    .font(.system(size: 24, weight: .bold))
                Text(nowPlaying.artist)
                
                
                Slider(
                    value: $playheadPosition,
                    in: 0...nowPlaying.duration, // min 1 second
                    step: 0.666 // 666 milliseconds
                    )
                    {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text(
                            Duration.seconds(playheadPosition)
                            .formatted(.time(pattern: .minuteSecond))
                        )
                    } maximumValueLabel: {
                        Text(
                            Duration.seconds(nowPlaying.duration)
                            .formatted(.time(pattern: .minuteSecond))
                        )
                    }
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length * 0.81
                    } /*onEditingChanged: { editing in
                        isEditing = editing
                    }
                    Text("\(speed)")
                        .foregroundColor(isEditing ? .red : .blue)*/
                
                HStack{
                    Button(action: replaySong) {
                        Image(systemName: "backward.end.fill")
                            .frame(width:36).font(.system(size: 28))
                            
                    }
                    Button(action: backwardSong) {
                        Image(systemName: "backward.fill")
                            .imageScale(.large)
                    }
                    Button(action: togglePlaySong) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .frame(width:64).font(.system(size: 36))
                    }
                    Button(action: forwardSong) {
                        Image(systemName: "forward.fill")
                            .imageScale(.large)
                    }
                    Button(action: skipSong) {
                        Image(systemName: "forward.end.fill")
                            .frame(width:36).font(.system(size: 28))
                    }
                }.frame(height: 64)
                
            }
    }
    
    private func replaySong() {
        
    }
    
    private func backwardSong() {
        
    }
    
    private func togglePlaySong() {
        isPlaying.toggle()
        
    }
    
    private func forwardSong() {
        
    }
    
    private func skipSong() {
        
    }
    

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
