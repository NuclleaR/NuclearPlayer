    //
    //  MiniPlayerView.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 11.09.2022.
    //

import SwiftUI

struct MiniPlayerView: View {
    var track: Track?
    var height: CGFloat = 60

    var isPlaying = false
    var posiition = 49.asCGFloat

    var onPlay: EmptyClosure = {}
    var onNext: EmptyClosure = {}
    var onOpenPlayer: EmptyClosure = {}

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "music.note")
                    .padding()
                if let track = track {
                    VStack(alignment: .leading) {
                        Text(track.title)
                        if !track.artist.isEmpty {
                            Text(track.artist)
                        }
                    }
                } else {
                    Text("No audio")
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onOpenPlayer)

            HStack(spacing: 0) {
                Button(action: onPlay) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 32))
                        .padding(2.0)
                }.disabled(track.notPresent)
                Button(action: onNext) {
                    Image(systemName: "forward.fill")
                        .padding(10.0)
                }.disabled(track.notPresent)
            }
        }
        .padding(.horizontal, 10.0)
        .frame(height: height)
        .background(.ultraThinMaterial)
        .overlay(Divider(), alignment: .top)
        .padding(.bottom, posiition)
    }
}

struct MiniPlayerView_Previews: PreviewProvider {
    static var track: Track = {
        let track = Track()
        track.title = "Test title"
        track.artist = "Test Artist"
        return track
    }()

    static var previews: some View {
        MiniPlayerView(
            track: MiniPlayerView_Previews.track
        )
        .previewLayout(.sizeThatFits)
        .previewDisplayName("With track")

        MiniPlayerView()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("With no track")
    }
}
