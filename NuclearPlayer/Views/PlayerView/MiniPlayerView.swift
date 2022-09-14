//
//  MiniPlayerView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 11.09.2022.
//

import SwiftUI

struct MiniPlayerView: View {
    var track: Track
    var height: CGFloat

    var isPlaying = false
    var posiition = 49.asCGFloat

    var onPlay: EmptyClosure
    var onNext: EmptyClosure
    var onOpenPlayer: EmptyClosure

    var body: some View {
        HStack {
            Image(systemName: "music.note")
                .padding()
            VStack(alignment: .leading) {
                Text(track.title)
                if !track.artist.isEmpty {
                    Text(track.artist)
                }
            }
            Spacer()
            HStack(spacing: 0) {
                Button(action: onPlay) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 32))
                        .padding(2.0)
                }
                Button(action: onNext) {
                    Image(systemName: "forward.fill")
                        .padding(10.0)
                }
            }
        }
        .onTapGesture(perform: onOpenPlayer)
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
            track: MiniPlayerView_Previews.track,
            height: 60,
            onPlay: {},
            onNext: {},
            onOpenPlayer: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
